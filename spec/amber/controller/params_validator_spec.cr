require "http"
require "../../../spec_helper"

class FakeController < Amber::Controller::Base
  contract("User") do
    param email : String, length: (50..50), regex: /\w+@\w+\.\w{2,}/
    param name : String, length: (1..20)
    param age : Int32, gte: 58, eq: 24, be: "Age"
    param alive : Bool, be: false
  end
end

module Amber
  describe Controller do
    context "when params is not within contract" do
      request = HTTP::Request.new(
        "GET",
        "/?user.address.street=303 Laerence Ave&" \
        "user.address.city=Jersey City&" \
        "user.address.state=NJ&" \
        "user.address.zip_code=60459&" \
        "email=eliasjprgmail.com&name=elias&age=37&alive=true"
      )

      controller = build_controller_for(request)

      it "does have have errors" do
        controller.user.valid?.should be_false
        controller.user.errors.empty?.should be_false
        controller.user.errors.size.should eq 5
        controller.user.errors.each do |error|
        end
      end
    end

    context "when params is within contract" do
    end
  end
end

def build_controller_for(request)
  request.headers.add("Referer", "")
  context = create_context(request)
  FakeController.new(context)
end
