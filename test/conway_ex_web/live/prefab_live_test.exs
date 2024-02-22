defmodule CWeb.PrefabLiveTest do
  use CWeb.ConnCase

  import Phoenix.LiveViewTest
  import C.DataFixtures

  @create_attrs %{data: "some data", name: "some name"}
  @update_attrs %{data: "some updated data", name: "some updated name"}
  @invalid_attrs %{data: nil, name: nil}

  defp create_prefab(_) do
    prefab = prefab_fixture()
    %{prefab: prefab}
  end

  describe "Index" do
    setup [:create_prefab]

    test "lists all prefabs", %{conn: conn, prefab: prefab} do
      {:ok, _index_live, html} = live(conn, ~p"/prefabs")

      assert html =~ "Listing Prefabs"
      assert html =~ prefab.data
    end

    test "saves new prefab", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/prefabs")

      assert index_live |> element("a", "New Prefab") |> render_click() =~
               "New Prefab"

      assert_patch(index_live, ~p"/prefabs/new")

      assert index_live
             |> form("#prefab-form", prefab: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#prefab-form", prefab: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/prefabs")

      html = render(index_live)
      assert html =~ "Prefab created successfully"
      assert html =~ "some data"
    end

    test "updates prefab in listing", %{conn: conn, prefab: prefab} do
      {:ok, index_live, _html} = live(conn, ~p"/prefabs")

      assert index_live |> element("#prefabs-#{prefab.id} a", "Edit") |> render_click() =~
               "Edit Prefab"

      assert_patch(index_live, ~p"/prefabs/#{prefab}/edit")

      assert index_live
             |> form("#prefab-form", prefab: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#prefab-form", prefab: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/prefabs")

      html = render(index_live)
      assert html =~ "Prefab updated successfully"
      assert html =~ "some updated data"
    end

    test "deletes prefab in listing", %{conn: conn, prefab: prefab} do
      {:ok, index_live, _html} = live(conn, ~p"/prefabs")

      assert index_live |> element("#prefabs-#{prefab.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#prefabs-#{prefab.id}")
    end
  end

  describe "Show" do
    setup [:create_prefab]

    test "displays prefab", %{conn: conn, prefab: prefab} do
      {:ok, _show_live, html} = live(conn, ~p"/prefabs/#{prefab}")

      assert html =~ "Show Prefab"
      assert html =~ prefab.data
    end

    test "updates prefab within modal", %{conn: conn, prefab: prefab} do
      {:ok, show_live, _html} = live(conn, ~p"/prefabs/#{prefab}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Prefab"

      assert_patch(show_live, ~p"/prefabs/#{prefab}/show/edit")

      assert show_live
             |> form("#prefab-form", prefab: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#prefab-form", prefab: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/prefabs/#{prefab}")

      html = render(show_live)
      assert html =~ "Prefab updated successfully"
      assert html =~ "some updated data"
    end
  end
end
