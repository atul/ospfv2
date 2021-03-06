#--
# Copyright 2010 Jean-Michel Esnault.
# All rights reserved.
# See LICENSE.txt for permissions.
#
#
# This file is part of OSPFv2.
# 
# OSPFv2 is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# OSPFv2 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with OSPFv2.  If not, see <http://www.gnu.org/licenses/>.
#++


require 'neighbor_sm/neighbor_state'
module OSPFv2
  module NeighborState
    class Full < State
      def recv_link_state_ack(neighbor, link_state_ack)
        neighbor.debug "*** in full state object ev recv_link_state_ack ????? ****"
      end
      def recv_dd(neighbor, dd)
        new_state neighbor, ExStart.new(neighbor), 'Received DatabaseDescription'
      end
    end
  end
end
