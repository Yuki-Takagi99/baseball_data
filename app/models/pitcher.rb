class Pitcher < ApplicationRecord
  def self.get_max_win_pitchers_id(pitchers)
    max_win = pitchers.maximum(:wins)
    best_pitchers = pitchers.where(wins: max_win)
    best_pitchers.pluck(:player_id)
  end

  def self.most_winners(year)
    pitchers = Pitcher.where(year_id: year) #引数の年のレコード配列をpitchersに代入
    get_max_win_pitchers_id(pitchers)
  end

  def self.top_ten(year)
    pitchers = Pitcher.where(year_id: year).order(wins: :desc) #指定した年のレコードの配列を降順にpitchersに代入
    if pitchers.count < 10
      best_pitchers = pitchers
    else
      tenth_win = pitchers.limit(10)[9].wins #pitchersのデータが10件以上の場合は、pitchersの10番目の要素の勝利数をtenth_winに代入
      best_pitchers = pitchers.where("wins >= ?", tenth_win) #pitchersの中で、勝利数がtenth_win以上のレコードを抽出し、best_pitchersに代入
    end
    best_pitchers.pluck(:player_id)
  end

  def self.most_winners_in_team(year, team)
    pitchers = Pitcher.where(year_id: year, team_id: team) #指定した年、指定したチームのレコードの配列をpitchersに代入
    get_max_win_pitchers_id(pitchers)
  end

  def self.most_winners_in_term(start_year, end_year)
    pitchers = Pitcher.where(year_id: start_year..end_year) #指定した期間のレコード配列をpitchersに代入
    get_max_win_pitchers_id(pitchers)
  end

  def self.best_deal(year)
    pitchers = Pitcher.where(year_id: year)
    cost_performance = 0 #初期値に0をセット
    best_pitchers = [] #空配列をセット
    pitchers.each do |pitcher| #繰り返し処理
      if Salary.exists?(year_id: year, player_id: pitcher.player_id) #条件に当てはまるデータが存在する場合
        win = pitcher.wins
        salary = Salary.find_by(year_id: year, player_id: pitcher.player_id).salary
        if cost_performance < win/salary.to_f
          cost_performance = win/salary.to_f
          best_pitchers = [pitcher]
        elsif cost_performance == win/salary.to_f
          best_pitchers.push(pitcher)
        end
      end
    end
    best_pitchers.pluck(:player_id)
  end
end
