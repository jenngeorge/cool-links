Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :allLinks, !types[Types::LinkType] do
    resolve -> (obj, args, ctx) {Link.all}
  end 
end
