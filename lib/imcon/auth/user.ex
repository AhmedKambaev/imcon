defmodule Imcon.Auth.User do
  
  use Ecto.Schema

  alias Imcon.Thorn.{Tree, UserTree}

  @derive {Poison.Encoder, only: [:id, :first_name, :last_name, :email, :is_admin]}

  schema "user" do
    
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :role, :string, default: "user"
    field :encrypted_password, :string
    field :password, :string, virtual: true

    has_many :owned_tree, Tree
    has_many :user_tree, UserTree
    has_many :tree, through: [:user_tree, :tree]

    timestamps()
  end

end
