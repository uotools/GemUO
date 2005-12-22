#
#  libuoclient-ruby
#  $Id$
#
#  (c) 2005 Max Kellermann <max@duempel.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; version 2 of the License.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#

module UO
    LOCK_UP = 0
    LOCK_DOWN = 1
    LOCK_LOCKED = 2

    SKILL_ALCHEMY = 0
    SKILL_ANATOMY = 1
    SKILL_ITEMID = 3
    SKILL_ARMSLORE = 4
    SKILL_DETECT_HIDDEN = 14
    SKILL_HIDING = 21
    SKILL_SPIRIT_SPEAK = 32

    class SkillValue
        def initialize(value, base, lock, cap)
            @value = value
            @base = base
            @lock = lock
            @cap = cap
        end

        def value
            @value
        end
        def base
            @base
        end
        def lock
            @lock
        end
        def cap
            @cap
        end

        def to_s
            "[value=#{@value} base=#{@base} lock=#{@lock} cap=#{@cap}]"
        end
    end

    class Walk
        def initialize(mobile)
            @mobile = mobile
            @next_seq = 0
        end
        def walk(direction)
            return unless @mobile.position
            return if @seq != nil
            @direction = direction & 0x7
            @seq = @next_seq
            @next_seq += 1
            @next_seq = 1 if @next_seq >= 0x100
            return UO::Packet::Walk.new(@direction, @seq)
        end
        def walk_reject(seq, x, y, z, direction)
            return unless @mobile.position

            # XXX resync when seq mismatch?
            @seq = nil
            @direction = nil
            @next_seq = 0
            @mobile.position = Position.new(x, y, z, direction)
        end
        def walk_ack(seq, notoriety)
            return unless @mobile.position

            if @seq != seq
                # XXX resync when seq mismatch?
            end

            oldpos = @mobile.position
            if oldpos.direction == @direction
                x, y = oldpos.x, oldpos.y
                case @direction
                when NORTH
                    y -= 1

                when NORTH_EAST
                    x += 1
                    y -= 1

                when EAST
                    x += 1

                when SOUTH_EAST
                    x += 1
                    y += 1

                when SOUTH
                    y += 1

                when SOUTH_WEST
                    x -= 1
                    y += 1

                when WEST
                    x -= 1

                when NORTH_WEST
                    x -= 1
                    y -= 1
                end

                @mobile.position = Position.new(x, y, oldpos.z, @direction)
            else
                @mobile.position = Position.new(oldpos.x, oldpos.y, oldpos.z,
                                                @direction)
            end

            @seq = nil
            @direction = nil
        end
    end
end
