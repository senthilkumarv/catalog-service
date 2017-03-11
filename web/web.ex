defmodule LoboCatalogService.Web do

  def controller do
    quote do
      use Phoenix.Controller
      import LoboCatalogService.Router.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      import Phoenix.Controller

      import LoboCatalogService.Router.Helpers
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
