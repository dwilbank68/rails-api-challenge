# require 'rails_helper'
#
# describe User do
#
#     before do
#         @user = User.new(name:'Porky Pig')
#     end
#
#     subject {@user}
#
#     it { should have_many :teams}
#     it { should have_many :monsters}
#     it { should respond_to :teams}
#     it { should respond_to :monsters}
#     it { should respond_to :name}
#     it { should validate_presence_of(:name) }
#     it { should respond_to :auth_token}
#     it { should allow_value("Dixie Cup").for(:name) }
#     it { should_not allow_value("D").for(:name) }
#     it { should_not allow_value("DDDDDEEEEEFFFFFGGGGGHHHHHIIIII").for(:name) }
#
#
# end