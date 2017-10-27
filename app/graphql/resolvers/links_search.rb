require 'search_object/plugin/graphql'

class Resolvers::LinksSearch
  include SearchObject.module(:graphql)

  # scope is a starting point for search
  scope { Link.all }

  type !types[Types::LinkType]

  LinkFilter = GraphQL::InputObjectType.define do
    name 'LinkFilter'

    argument :OR, -> { types[LinkFilter] }
    argument :description_contains, types.String
    argument :url_contains, types.String
  end

  # when 'filter' is passed, 'apply_filter' would be called to narrow the scope
  option :filter, type: LinkFilter, with: :apply_filter

  # apply_filter recursively loops through "OR" branches
  def apply_filter(scope, value)
    # normalize filters from nested OR structure, to flat scope list
    branches = normalize_filters(value).reduce { |a, b| a.or(b)}
    scope.merge branches
  end

  def normalize_filters(value, branches = [])
    # add like SQL conditions
    scope = Link.all
    scope = scope.where('description LIKE ?', "%#{value['description_contains']}%") if value['description_contains']
    scope = scope.where('url LIKE ?', "%#{value['url_contains']}%") if value['url_contains']

    branches << scope

    value['OR'].reduce(branches) { |s, v| normalize_filters(v, s) } if value['OR'].present?

    branches
  end
end