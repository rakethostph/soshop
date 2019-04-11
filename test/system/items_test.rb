require "application_system_test_case"

class ItemsTest < ApplicationSystemTestCase
  setup do
    @item = items(:one)
  end

  test "visiting the index" do
    visit items_url
    assert_selector "h1", text: "Items"
  end

  test "creating a Item" do
    visit items_url
    click_on "New Item"

    fill_in "Item av rating", with: @item.item_av_rating
    fill_in "Item currency symbol", with: @item.item_currency_symbol
    fill_in "Item details", with: @item.item_details
    fill_in "Item image", with: @item.item_image
    fill_in "Item location", with: @item.item_location
    fill_in "Item name", with: @item.item_name
    fill_in "Item new price", with: @item.item_new_price
    fill_in "Item old price", with: @item.item_old_price
    fill_in "Item reviews", with: @item.item_reviews
    fill_in "Item seller name", with: @item.item_seller_name
    fill_in "Item sku", with: @item.item_sku
    fill_in "Item url", with: @item.item_url
    click_on "Create Item"

    assert_text "Item was successfully created"
    click_on "Back"
  end

  test "updating a Item" do
    visit items_url
    click_on "Edit", match: :first

    fill_in "Item av rating", with: @item.item_av_rating
    fill_in "Item currency symbol", with: @item.item_currency_symbol
    fill_in "Item details", with: @item.item_details
    fill_in "Item image", with: @item.item_image
    fill_in "Item location", with: @item.item_location
    fill_in "Item name", with: @item.item_name
    fill_in "Item new price", with: @item.item_new_price
    fill_in "Item old price", with: @item.item_old_price
    fill_in "Item reviews", with: @item.item_reviews
    fill_in "Item seller name", with: @item.item_seller_name
    fill_in "Item sku", with: @item.item_sku
    fill_in "Item url", with: @item.item_url
    click_on "Update Item"

    assert_text "Item was successfully updated"
    click_on "Back"
  end

  test "destroying a Item" do
    visit items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Item was successfully destroyed"
  end
end
