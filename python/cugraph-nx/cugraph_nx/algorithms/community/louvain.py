# Copyright (c) 2023, NVIDIA CORPORATION.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
import sys

import pylibcugraph as plc

from cugraph_nx.convert import _to_undirected_graph
from cugraph_nx.utils import _groupby, networkx_algorithm, not_implemented_for

__all__ = ["louvain_communities"]


@not_implemented_for("directed")
@networkx_algorithm(extra_params="max_level")
def louvain_communities(
    G, weight="weight", resolution=1, threshold=0.0000001, seed=None, *, max_level=None
):
    """`threshold` and `seed` parameters are currently ignored.

    Extra parameter: `max_level` controls the maximum number of levels of the algorithm.
    """
    # NetworkX allows both directed and undirected, but cugraph only allows undirected.
    G = _to_undirected_graph(G, weight)
    if G.row_indices.size == 0:
        # TODO: PLC doesn't handle empty graphs gracefully!
        return [{key} for key in G._nodeiter_to_iter(range(len(G)))]
    if max_level is None:
        max_level = sys.maxsize
    vertices, clusters, modularity = plc.louvain(
        resource_handle=plc.ResourceHandle(),
        graph=G._get_plc_graph(),
        max_level=max_level,  # TODO: add this parameter to NetworkX
        resolution=resolution,
        # threshold=threshold,  # TODO: add this parameter to PLC
        do_expensive_check=False,
    )
    groups = _groupby(clusters, vertices)
    return [set(G._nodearray_to_list(node_ids)) for node_ids in groups.values()]


@louvain_communities._can_run
def _(
    G, weight="weight", resolution=1, threshold=0.0000001, seed=None, *, max_level=None
):
    # NetworkX allows both directed and undirected, but cugraph only allows undirected.
    return not G.is_directed()
