/*
 * Copyright (c) 2021-2023, NVIDIA CORPORATION.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <structure/decompress_to_edgelist_impl.cuh>

namespace cugraph {

// SG instantiation

template std::tuple<rmm::device_uvector<int32_t>,
                    rmm::device_uvector<int32_t>,
                    std::optional<rmm::device_uvector<float>>,
                    std::optional<rmm::device_uvector<int32_t>>>
decompress_to_edgelist<int32_t, int32_t, float, false, false>(
  raft::handle_t const& handle,
  graph_view_t<int32_t, int32_t, false, false> const& graph_view,
  std::optional<edge_property_view_t<int32_t, float const*>> edge_weight_view,
  std::optional<edge_property_view_t<int32_t, int32_t const*>> edge_id_view,
  std::optional<raft::device_span<int32_t const>> renumber_map,
  bool do_expensive_check);

template std::tuple<rmm::device_uvector<int32_t>,
                    rmm::device_uvector<int32_t>,
                    std::optional<rmm::device_uvector<float>>,
                    std::optional<rmm::device_uvector<int32_t>>>
decompress_to_edgelist<int32_t, int32_t, float, true, false>(
  raft::handle_t const& handle,
  graph_view_t<int32_t, int32_t, true, false> const& graph_view,
  std::optional<edge_property_view_t<int32_t, float const*>> edge_weight_view,
  std::optional<edge_property_view_t<int32_t, int32_t const*>> edge_id_view,
  std::optional<raft::device_span<int32_t const>> renumber_map,
  bool do_expensive_check);

template std::tuple<rmm::device_uvector<int32_t>,
                    rmm::device_uvector<int32_t>,
                    std::optional<rmm::device_uvector<double>>,
                    std::optional<rmm::device_uvector<int32_t>>>
decompress_to_edgelist<int32_t, int32_t, double, false, false>(
  raft::handle_t const& handle,
  graph_view_t<int32_t, int32_t, false, false> const& graph_view,
  std::optional<edge_property_view_t<int32_t, double const*>> edge_weight_view,
  std::optional<edge_property_view_t<int32_t, int32_t const*>> edge_id_view,
  std::optional<raft::device_span<int32_t const>> renumber_map,
  bool do_expensive_check);

template std::tuple<rmm::device_uvector<int32_t>,
                    rmm::device_uvector<int32_t>,
                    std::optional<rmm::device_uvector<double>>,
                    std::optional<rmm::device_uvector<int32_t>>>
decompress_to_edgelist<int32_t, int32_t, double, true, false>(
  raft::handle_t const& handle,
  graph_view_t<int32_t, int32_t, true, false> const& graph_view,
  std::optional<edge_property_view_t<int32_t, double const*>> edge_weight_view,
  std::optional<edge_property_view_t<int32_t, int32_t const*>> edge_id_view,
  std::optional<raft::device_span<int32_t const>> renumber_map,
  bool do_expensive_check);

template std::tuple<rmm::device_uvector<int32_t>,
                    rmm::device_uvector<int32_t>,
                    std::optional<rmm::device_uvector<float>>,
                    std::optional<rmm::device_uvector<int64_t>>>
decompress_to_edgelist<int32_t, int64_t, float, false, false>(
  raft::handle_t const& handle,
  graph_view_t<int32_t, int64_t, false, false> const& graph_view,
  std::optional<edge_property_view_t<int64_t, float const*>> edge_weight_view,
  std::optional<edge_property_view_t<int64_t, int64_t const*>> edge_id_view,
  std::optional<raft::device_span<int32_t const>> renumber_map,
  bool do_expensive_check);

template std::tuple<rmm::device_uvector<int32_t>,
                    rmm::device_uvector<int32_t>,
                    std::optional<rmm::device_uvector<float>>,
                    std::optional<rmm::device_uvector<int64_t>>>
decompress_to_edgelist<int32_t, int64_t, float, true, false>(
  raft::handle_t const& handle,
  graph_view_t<int32_t, int64_t, true, false> const& graph_view,
  std::optional<edge_property_view_t<int64_t, float const*>> edge_weight_view,
  std::optional<edge_property_view_t<int64_t, int64_t const*>> edge_id_view,
  std::optional<raft::device_span<int32_t const>> renumber_map,
  bool do_expensive_check);

template std::tuple<rmm::device_uvector<int32_t>,
                    rmm::device_uvector<int32_t>,
                    std::optional<rmm::device_uvector<double>>,
                    std::optional<rmm::device_uvector<int64_t>>>
decompress_to_edgelist<int32_t, int64_t, double, false, false>(
  raft::handle_t const& handle,
  graph_view_t<int32_t, int64_t, false, false> const& graph_view,
  std::optional<edge_property_view_t<int64_t, double const*>> edge_weight_view,
  std::optional<edge_property_view_t<int64_t, int64_t const*>> edge_id_view,
  std::optional<raft::device_span<int32_t const>> renumber_map,
  bool do_expensive_check);

template std::tuple<rmm::device_uvector<int32_t>,
                    rmm::device_uvector<int32_t>,
                    std::optional<rmm::device_uvector<double>>,
                    std::optional<rmm::device_uvector<int64_t>>>
decompress_to_edgelist<int32_t, int64_t, double, true, false>(
  raft::handle_t const& handle,
  graph_view_t<int32_t, int64_t, true, false> const& graph_view,
  std::optional<edge_property_view_t<int64_t, double const*>> edge_weight_view,
  std::optional<edge_property_view_t<int64_t, int64_t const*>> edge_id_view,
  std::optional<raft::device_span<int32_t const>> renumber_map,
  bool do_expensive_check);

template std::tuple<rmm::device_uvector<int64_t>,
                    rmm::device_uvector<int64_t>,
                    std::optional<rmm::device_uvector<float>>,
                    std::optional<rmm::device_uvector<int64_t>>>
decompress_to_edgelist<int64_t, int64_t, float, false, false>(
  raft::handle_t const& handle,
  graph_view_t<int64_t, int64_t, false, false> const& graph_view,
  std::optional<edge_property_view_t<int64_t, float const*>> edge_weight_view,
  std::optional<edge_property_view_t<int64_t, int64_t const*>> edge_id_view,
  std::optional<raft::device_span<int64_t const>> renumber_map,
  bool do_expensive_check);

template std::tuple<rmm::device_uvector<int64_t>,
                    rmm::device_uvector<int64_t>,
                    std::optional<rmm::device_uvector<float>>,
                    std::optional<rmm::device_uvector<int64_t>>>
decompress_to_edgelist<int64_t, int64_t, float, true, false>(
  raft::handle_t const& handle,
  graph_view_t<int64_t, int64_t, true, false> const& graph_view,
  std::optional<edge_property_view_t<int64_t, float const*>> edge_weight_view,
  std::optional<edge_property_view_t<int64_t, int64_t const*>> edge_id_view,
  std::optional<raft::device_span<int64_t const>> renumber_map,
  bool do_expensive_check);

template std::tuple<rmm::device_uvector<int64_t>,
                    rmm::device_uvector<int64_t>,
                    std::optional<rmm::device_uvector<double>>,
                    std::optional<rmm::device_uvector<int64_t>>>
decompress_to_edgelist<int64_t, int64_t, double, false, false>(
  raft::handle_t const& handle,
  graph_view_t<int64_t, int64_t, false, false> const& graph_view,
  std::optional<edge_property_view_t<int64_t, double const*>> edge_weight_view,
  std::optional<edge_property_view_t<int64_t, int64_t const*>> edge_id_view,
  std::optional<raft::device_span<int64_t const>> renumber_map,
  bool do_expensive_check);

template std::tuple<rmm::device_uvector<int64_t>,
                    rmm::device_uvector<int64_t>,
                    std::optional<rmm::device_uvector<double>>,
                    std::optional<rmm::device_uvector<int64_t>>>
decompress_to_edgelist<int64_t, int64_t, double, true, false>(
  raft::handle_t const& handle,
  graph_view_t<int64_t, int64_t, true, false> const& graph_view,
  std::optional<edge_property_view_t<int64_t, double const*>> edge_weight_view,
  std::optional<edge_property_view_t<int64_t, int64_t const*>> edge_id_view,
  std::optional<raft::device_span<int64_t const>> renumber_map,
  bool do_expensive_check);

}  // namespace cugraph
