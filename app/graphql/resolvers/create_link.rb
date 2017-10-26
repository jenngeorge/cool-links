class Resolvers::CreateLink < GraphQL::Function
  # arguments passed as 'args'
  argument :description, !types.String
  argument :url, !types.String

  # return type from the mutation
  type Types::LinkType

  # the mutation method!
  # _obj - the parent object, which in this case is nil
  # args - the passed arguments
  # _ctx - the GraphQL context
  def call(_obj, args, _ctx)
    Link.create!(
      description: args[:description],
      url: args[:url],
      user: _ctx[:current_user]
    )
  end
end
