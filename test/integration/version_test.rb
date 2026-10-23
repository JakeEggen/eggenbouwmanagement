require "test_helper"

class VersionTest < ActionDispatch::IntegrationTest
  test "layout includes the deployed commit" do
    ENV["RENDER_GIT_COMMIT"] = "abc123"
    get root_path
    assert_select 'meta[name="app-version"][content="abc123"]'
  ensure
    ENV.delete("RENDER_GIT_COMMIT")
  end
end
