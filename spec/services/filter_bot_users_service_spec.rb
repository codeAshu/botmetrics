RSpec.describe FilterBotUsersService do
  describe '#scope' do
    let!(:bot)        { create(:bot) }
    let!(:instance_1) { create(:bot_instance, :with_attributes, uid: '123', bot: bot, state: 'enabled') }

    let!(:bot_user_1) { create(:bot_user, bot_instance: instance_1, user_attributes: { nickname: 'john', email: 'john@example.com' }) }
    let!(:bot_user_2) { create(:bot_user, bot_instance: instance_1, user_attributes: { nickname: 'sean', email: 'sean@example.com' }) }
    let!(:bot_user_3) { create(:bot_user, bot_instance: instance_1, user_attributes: { nickname: 'mike', email: 'mike@example.com' }) }

    ##### These do not appear - START
    let!(:instance_2) { create(:bot_instance, :with_attributes, uid: '456', bot: bot, state: 'pending') }

    let!(:bot_user_4) { create(:bot_user, bot_instance: instance_2, user_attributes: { nickname: 'johny', email: 'johny@example.com' }) }
    let!(:bot_user_5) { create(:bot_user, bot_instance: instance_2, user_attributes: { nickname: 'seany', email: 'seany@example.com' }) }
    let!(:bot_user_6) { create(:bot_user, bot_instance: instance_2, user_attributes: { nickname: 'mikey', email: 'mikey@example.com' }) }
    ##### These do not appear - END

    let(:service)   { FilterBotUsersService.new(bot, query_set) }
    let(:query_set) { QuerySet.new(queries: queries)}

    context 'empty query' do
      let(:queries)   { [Query.new(field: :nickname, method: :contains, value: nil)] }

      it 'returns all' do
        expect(service.scope.map(&:id)).to eq [bot_user_1, bot_user_2, bot_user_3].map(&:id)
      end
    end

    context 'one query' do
      let(:queries)   { [Query.new(field: :nickname, method: :contains, value: 'sean')] }

      it 'returns filtered' do
        expect(service.scope.map(&:id)).to eq [bot_user_2].map(&:id)
      end
    end

    context 'many queries' do
      let(:queries) do
        [
          Query.new(field: :nickname, method: :contains, value: 'mike'),
          Query.new(field: :email,    method: :contains, value: 'example')
        ]
      end

      it 'returns filtered' do
        expect(service.scope.map(&:id)).to eq [bot_user_3].map(&:id)
      end
    end
  end
end
