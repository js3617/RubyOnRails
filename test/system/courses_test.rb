require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
  end

  test "visiting the index" do
    visit courses_url
    assert_selector "h1", text: "Courses"
  end

  test "creating a Course" do
    visit courses_url
    click_on "New Course"

    check "Certificate" if @course.certificate
    fill_in "Class name", with: @course.class_name
    fill_in "Description", with: @course.description
    fill_in "Level", with: @course.level
    fill_in "Like", with: @course.like
    fill_in "Price", with: @course.price
    fill_in "Provider", with: @course.provider
    fill_in "Rating", with: @course.rating
    fill_in "Sessions count", with: @course.sessions_count
    fill_in "Youtube playlist", with: @course.youtube_playlist_id
    click_on "Create Course"

    assert_text "Course was successfully created"
    click_on "Back"
  end

  test "updating a Course" do
    visit courses_url
    click_on "Edit", match: :first

    check "Certificate" if @course.certificate
    fill_in "Class name", with: @course.class_name
    fill_in "Description", with: @course.description
    fill_in "Level", with: @course.level
    fill_in "Like", with: @course.like
    fill_in "Price", with: @course.price
    fill_in "Provider", with: @course.provider
    fill_in "Rating", with: @course.rating
    fill_in "Sessions count", with: @course.sessions_count
    fill_in "Youtube playlist", with: @course.youtube_playlist_id
    click_on "Update Course"

    assert_text "Course was successfully updated"
    click_on "Back"
  end

  test "destroying a Course" do
    visit courses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Course was successfully destroyed"
  end
end
