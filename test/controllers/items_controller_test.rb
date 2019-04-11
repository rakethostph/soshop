require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:one)
  end

  test "should get index" do
    get items_url
    assert_response :success
  end

  test "should get new" do
    get new_item_url
    assert_response :success
  end

  test "should create item" do
    assert_difference('Item.count') do
      post items_url, params: { item: { item_av_rating: @item.item_av_rating, item_currency_symbol: @item.item_currency_symbol, item_details: @item.item_details, item_image: @item.item_image, item_location: @item.item_location, item_name: @item.item_name, item_new_price: @item.item_new_price, item_old_price: @item.item_old_price, item_reviews: @item.item_reviews, item_seller_name: @item.item_seller_name, item_sku: @item.item_sku, item_url: @item.item_url } }
    end

    assert_redirected_to item_url(Item.last)
  end

  test "should show item" do
    get item_url(@item)
    assert_response :success
  end

  test "should get edit" do
    get edit_item_url(@item)
    assert_response :success
  end

  test "should update item" do
    patch item_url(@item), params: { item: { item_av_rating: @item.item_av_rating, item_currency_symbol: @item.item_currency_symbol, item_details: @item.item_details, item_image: @item.item_image, item_location: @item.item_location, item_name: @item.item_name, item_new_price: @item.item_new_price, item_old_price: @item.item_old_price, item_reviews: @item.item_reviews, item_seller_name: @item.item_seller_name, item_sku: @item.item_sku, item_url: @item.item_url } }
    assert_redirected_to item_url(@item)
  end

  test "should destroy item" do
    assert_difference('Item.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
  end
end
