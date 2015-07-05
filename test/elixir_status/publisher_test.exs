defmodule ElixirStatus.PublisherTest do
  use ElixirStatus.ModelCase

  alias ElixirStatus.Publisher
  alias ElixirStatus.Posting

  @valid_attrs %{permalink: "some-content", public: true, published_at: %{day: 17, hour: 14, min: 0, month: 4, year: 2010}, scheduled_at: %{day: 17, hour: 14, min: 0, month: 4, year: 2010}, text: "some content", title: "some content", uid: "some content", user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Posting.changeset(%Posting{}, @valid_attrs)
    assert changeset.valid?

    Repo.insert!(changeset)
      |> Publisher.after_create
  end

  test "short title for long titles" do
    input = "Remember this function works with unicode codepoints and consider the slices to represent codepoints offsets. If you want to split on raw bytes, check Kernel.binary_part/3 instead."
    expected = "Remembe..."
    result = Publisher.short_title(input, 10)
    assert 10 == String.length(result)
    assert expected == result
  end

  test "short title for short titles" do
    input = "Remember"
    expected = "Remember"
    result = Publisher.short_title(input, 10)
    assert String.length(input) < 10
    assert expected == result
  end

  test "permalink" do
    expected = "aB87-i-really-like-this-title"
    result = Publisher.permalink("aB87", "I really like this TiTlE")
    assert expected == result
  end
end
