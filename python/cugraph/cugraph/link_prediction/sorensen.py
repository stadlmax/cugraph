# Copyright (c) 2021-2023, NVIDIA CORPORATION.
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

import cudf
from cugraph.structure.graph_classes import Graph
from cugraph.link_prediction import jaccard_wrapper
from cugraph.utilities import (
    ensure_cugraph_obj_for_nx,
    df_edge_score_to_dictionary,
    renumber_vertex_pair,
)


def sorensen(input_graph, vertex_pair=None, do_expensive_check=True):
    """
    Compute the Sorensen coefficient between each pair of vertices connected by
    an edge, or between arbitrary pairs of vertices specified by the user.
    Sorensen coefficient is defined between two sets as the ratio of twice the
    volume of their intersection divided by the volume of each set.
    If first is specified but second is not, or vice versa, an exception will
    be thrown.

    NOTE: This algorithm doesn't currently support datasets with vertices that
    are not (re)numebred vertices from 0 to V-1 where V is the total number of
    vertices as this creates isolated vertices.

    cugraph.sorensen, in the absence of a specified vertex pair list, will
    use the edges of the graph to construct a vertex pair list and will
    return the sorensen coefficient for those vertex pairs.

    Parameters
    ----------
    input_graph : cugraph.Graph
        cuGraph Graph instance, should contain the connectivity information
        as an edge list (edge weights are not used for this algorithm). The
        graph should be undirected where an undirected edge is represented by a
        directed edge in both direction. The adjacency list will be computed if
        not already present.

    vertex_pair : cudf.DataFrame, optional (default=None)
        A GPU dataframe consisting of two columns representing pairs of
        vertices. If provided, the Sorensen coefficient is computed for the
        given vertex pairs.  If the vertex_pair is not provided then the
        current implementation computes the Sorensen coefficient for all
        adjacent vertices in the graph.

    do_expensive_check: bool (default=True)
        When set to True, check if the vertices in the graph are (re)numbered
        from 0 to V-1 where V is the total number of vertices.

    Returns
    -------
    df  : cudf.DataFrame
        GPU data frame of size E (the default) or the size of the given pairs
        (first, second) containing the Sorensen index. The ordering is
        relative to the adjacency list, or that given by the specified vertex
        pairs.

        df['first'] : cudf.Series
            The first vertex ID of each pair (will be identical to first if specified)

        df['second'] : cudf.Series
            The second vertex ID of each pair (will be identical to second if
            specified)

        df['sorensen_coeff'] : cudf.Series
            The computed Sorensen coefficient between the first and the second
            vertex ID.

    Examples
    --------
    >>> from cugraph.datasets import karate
    >>> G = karate.get_graph(download=True)
    >>> df = cugraph.sorensen(G)

    """
    if do_expensive_check:
        if not input_graph.renumbered:
            input_df = input_graph.edgelist.edgelist_df[["src", "dst"]]
            max_vertex = input_df.max().max()
            expected_nodes = cudf.Series(range(0, max_vertex + 1, 1)).astype(
                input_df.dtypes[0]
            )
            nodes = (
                cudf.concat([input_df["src"], input_df["dst"]])
                .unique()
                .sort_values()
                .reset_index(drop=True)
            )
            if not expected_nodes.equals(nodes):
                raise ValueError("Unrenumbered vertices are not supported.")

    if type(input_graph) is not Graph:
        raise TypeError("input graph must a Graph")

    if type(vertex_pair) == cudf.DataFrame:
        vertex_pair = renumber_vertex_pair(input_graph, vertex_pair)
    elif vertex_pair is not None:
        raise ValueError("vertex_pair must be a cudf dataframe")

    df = jaccard_wrapper.jaccard(input_graph, None, vertex_pair)
    df.jaccard_coeff = (2 * df.jaccard_coeff) / (1 + df.jaccard_coeff)
    df.rename({"jaccard_coeff": "sorensen_coeff"}, axis=1, inplace=True)
    if input_graph.renumbered:
        df = input_graph.unrenumber(df, "first")
        df = input_graph.unrenumber(df, "second")

    return df


def sorensen_coefficient(G, ebunch=None, do_expensive_check=True):
    """
    For NetworkX Compatability.  See `sorensen`

    NOTE: This algorithm doesn't currently support datasets with vertices that
    are not (re)numebred vertices from 0 to V-1 where V is the total number of
    vertices as this creates isolated vertices.

    Parameters
    ----------
    G : cugraph.Graph
        cuGraph Graph instance, should contain the connectivity information
        as an edge list (edge weights are not used for this algorithm). The
        graph should be undirected where an undirected edge is represented by a
        directed edge in both direction. The adjacency list will be computed if
        not already present.
    ebunch : cudf.DataFrame, optional (default=None)
        A GPU dataframe consisting of two columns representing pairs of
        vertices. If provided, the sorensen coefficient is computed for the
        given vertex pairs.  If the vertex_pair is not provided then the
        current implementation computes the sorensen coefficient for all
        adjacent vertices in the graph.

    Returns
    -------
    df  : cudf.DataFrame
        GPU data frame of size E (the default) or the size of the given pairs
        (first, second) containing the Sorensen weights. The ordering is
        relative to the adjacency list, or that given by the specified vertex
        pairs.

        df['first'] : cudf.Series
            The first vertex ID of each pair (will be identical to first if specified).
        df['second'] : cudf.Series
            the second vertex ID of each pair (will be identical to second if
            specified).
        df['sorensen_coeff'] : cudf.Series
            The computed Sorensen coefficient between the first and the second
            vertex ID.

    Examples
    --------
    >>> from cugraph.datasets import karate
    >>> G = karate.get_graph(download=True)
    >>> df = cugraph.sorensen_coefficient(G)

    """
    vertex_pair = None

    G, isNx = ensure_cugraph_obj_for_nx(G)

    if isNx is True and ebunch is not None:
        vertex_pair = cudf.DataFrame(ebunch)

    df = sorensen(G, vertex_pair)

    if isNx is True:
        df = df_edge_score_to_dictionary(
            df, k="sorensen_coeff", src="first", dst="second"
        )

    return df
