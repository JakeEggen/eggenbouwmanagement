require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test "gallery uses thumbnails instead of full-size originals" do
    get projects_url
    assert_response :success
    assert_select ".project-gallery img[src*='projects/thumbs/']"
    assert_select ".project-gallery__item[data-src*='projects/large/']"
    assert_select ".lot-lightbox__thumb img[src*='projects/thumbs/']"
  end
end
