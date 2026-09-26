require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test "gallery uses thumbnails instead of full-size originals" do
    get projects_url
    assert_response :success
    assert_select ".project-gallery img[src*='projects/thumbs/']"
    assert_select ".project-gallery__item[data-src*='projects/large/']"
    assert_select ".lot-lightbox__thumb img[src*='projects/thumbs/']"
    assert_select ".project-gallery__item[data-category='sport']", count: 2
    assert_select ".project-gallery__item[data-category='sport'][data-src*='2_IMG_2101']", count: 1
    assert_select ".project-gallery__item[data-category='sport'][data-src*='20_renkum']", count: 1
    assert_select ".project-gallery__item[data-category='school']", count: 5
    assert_select ".project-gallery__item[data-category='woningbouw']", count: 8
    assert_select ".project-gallery__item[data-category='woningbouw'][data-src*='7_SAM_2328']", count: 1
    assert_select ".project-filters__btn", text: "Winkel"
    assert_select ".project-filters__btn", text: "Onderhoud"
    assert_select ".project-gallery__item[data-category='onderhoud'][data-src*='19_Wijert']", count: 1
  end
end
