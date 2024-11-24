require "application_system_test_case"

class ClassListsTest < ApplicationSystemTestCase
  setup do
    @class_list = class_lists(:one)
  end

  test "visiting the index" do
    visit class_lists_url
    assert_selector "h1", text: "Class Lists"
  end

  test "creating a Class list" do
    visit class_lists_url
    click_on "New Class List"

    fill_in "Course", with: @class_list.course_id
    fill_in "Description", with: @class_list.description
    fill_in "Duration", with: @class_list.duration
    fill_in "Lesson name", with: @class_list.lesson_name
    fill_in "Youtube video", with: @class_list.youtube_video_id
    click_on "Create Class list"

    assert_text "Class list was successfully created"
    click_on "Back"
  end

  test "updating a Class list" do
    visit class_lists_url
    click_on "Edit", match: :first

    fill_in "Course", with: @class_list.course_id
    fill_in "Description", with: @class_list.description
    fill_in "Duration", with: @class_list.duration
    fill_in "Lesson name", with: @class_list.lesson_name
    fill_in "Youtube video", with: @class_list.youtube_video_id
    click_on "Update Class list"

    assert_text "Class list was successfully updated"
    click_on "Back"
  end

  test "destroying a Class list" do
    visit class_lists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Class list was successfully destroyed"
  end
end
