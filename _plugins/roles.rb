module Roles
  class RoleIcons
    def initialize(roles)
      @roles = roles
      @role_icons = role_icons
    end

    def role_icons
      role_icons = Hash.new
      for item in @roles
        if item.key?('role') and item.key?('icon')
          role_icons[item['role']] = item['icon']

          if item.key?('aliases')
            for item_alias in item['aliases']
              role_icons[item_alias] = item['icon']
            end
          end
        end
      end

      return role_icons
    end

    def to_liquid
      @role_icons
    end
  end

  class RoleMap
    def initialize(roles)
      @roles = roles
      @role_map = role_map
    end

    def role_map
      role_map = Hash.new
      for item in @roles
        role_map[item['role']] = item['role']

        if item.key?('aliases')
          for item_alias in item['aliases']
            role_map[item_alias] = item['role']
          end
        end
      end

      return role_map
    end

    def to_liquid
      @role_map
    end
  end
end
