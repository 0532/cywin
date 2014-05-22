require 'spec_helper'

describe SyndicatesController do

  describe "GET 'index'" do
    before do
      @user = create_investor_user
      project = create_project_with_owner(@user)
      project.money_requires << build(:money_require)
      project.save!
      @money_require = project.money_requires.first
      @money_require.quickly_turn_on!(@user.id)
    end

    it "success" do
      # invest first
      investment = Investment.new( money: 1000 )
      investment.user = @user
      investment.money_require = @money_require
      investment.save!
      xhr :get, :index, money_require_id: @money_require.id
      res = JSON.parse(response.body)
      expect(res['investments'].size).to eq(1)
    end
  end

  describe "POST 'syndicate'" do

    login_user
    before do
      project = create_project_with_owner(@user)
      project.money_requires << build(:money_require)
      project.save!
      @money_require = project.money_requires.first
    end

    it "success" do
      @user = create_investor_user(@user)
      @money_require.quickly_turn_on!(@user.id)
      expect(@money_require.reload.progress).to eq(0)
      xhr :post, 'create', ActionController::Parameters.new( money_require_id: @money_require.id, money: 1000 )
      check_json(response.body, :success, true)
      expect(@money_require.reload.progress).not_to eq(0)
    end

    it "追加投资成功" do
      @user = create_investor_user(@user)
      @money_require.quickly_turn_on!(@user.id)
      expect(@money_require.reload.progress).to eq(0)
      investment = Investment.create!(money: 1000, money_require_id: @money_require.id)
      investment.user = @user
      investment.save!
      xhr :patch, 'update', ActionController::Parameters.new( money: 1000, id: investment.id )
      check_json(response.body, :success, true)
      expect(@money_require.reload.progress).not_to eq(0)
    end

    it "没有申请投资人失败" do
      @money_require.quickly_turn_on!(1)
      expect(@money_require.reload.progress).to eq(0)
      post 'create', ActionController::Parameters.new(money_require_id: @money_require.id, money: 10 )
      response.should redirect_to( root_path )
    end
    
    it "没有领投时失败" do
      @user = create_investor_user(@user)
      @money_require.preheat!
      expect(@money_require.reload.progress).to eq(0)
      post 'create', ActionController::Parameters.new(money_require_id: @money_require.id, money: 10 )
      check_json(response.body, :success, false)
    end
  end

end
