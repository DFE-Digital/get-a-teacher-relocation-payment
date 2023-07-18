# frozen_string_literal: true

require "rails_helper"

describe "CRUD USERS" do
  include AdminHelpers

  it "List Users" do
    given_there_are_users
    given_i_am_signed_as_an_admin
    when_i_am_in_the_users_page
    then_i_can_see_the_users_list
  end

  it "Create User" do
    given_i_am_signed_as_an_admin
    when_i_am_in_the_users_page
    then_i_can_create_a_user
  end

  it "Update User" do
    given_there_are_users
    given_i_am_signed_as_an_admin
    when_i_am_in_the_users_page
    then_i_can_update_a_user
  end

  it "Delete User" do
    given_there_is_are_users
    given_i_am_signed_as_an_admin
    when_i_am_in_the_users_page
    then_i_can_delete_a_user
  end

private

  def given_there_are_users
    create(:user, email: "john@example.com")
    create(:user, email: "jane@example.com")
  end

  def when_i_am_in_the_users_page
    visit users_path
  end

  def then_i_can_see_the_users_list
    within ".users-table" do
      expect(page).to have_content("jane@example.com")
      expect(page).to have_content("john@example.com")
    end
  end

  def then_i_can_create_a_user
    click_on "New user"
    fill_in "Email", with: "new_user@example.com"
    click_on "Save"
    expect(page).to have_content("User was successfully created.")
    expect(page).to have_content("new_user@example.com")
  end

  def then_i_can_update_a_user
    click_on "john@example.com"
    fill_in "Email", with: "new_user@example.com"
    click_on "Save"
    expect(page).to have_content("User was successfully updated.")
    expect(page).to have_content("new_user@example.com")
  end

  def then_i_can_delete_a_user
    within(".users-table tbody tr:first-child") do
      click_on "Delete"
    end
    expect(page).to have_content("User was successfully destroyed.")
    expect(page).not_to have_content("john@example.com")
  end
end
