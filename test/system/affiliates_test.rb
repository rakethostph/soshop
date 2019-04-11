require "application_system_test_case"

class AffiliatesTest < ApplicationSystemTestCase
  setup do
    @affiliate = affiliates(:one)
  end

  test "visiting the index" do
    visit affiliates_url
    assert_selector "h1", text: "Affiliates"
  end

  test "creating a Affiliate" do
    visit affiliates_url
    click_on "New Affiliate"

    fill_in "Affiliate company", with: @affiliate.affiliate_company
    fill_in "Affiliate", with: @affiliate.affiliate_id
    fill_in "Affiliate name", with: @affiliate.affiliate_name
    click_on "Create Affiliate"

    assert_text "Affiliate was successfully created"
    click_on "Back"
  end

  test "updating a Affiliate" do
    visit affiliates_url
    click_on "Edit", match: :first

    fill_in "Affiliate company", with: @affiliate.affiliate_company
    fill_in "Affiliate", with: @affiliate.affiliate_id
    fill_in "Affiliate name", with: @affiliate.affiliate_name
    click_on "Update Affiliate"

    assert_text "Affiliate was successfully updated"
    click_on "Back"
  end

  test "destroying a Affiliate" do
    visit affiliates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Affiliate was successfully destroyed"
  end
end
