# encoding: utf-8
module SocialHelper

  def twitter_subscribe
    account = 'insomnis_story'
    ("<a href=\"https://twitter.com/#{account}\"" +
       ' class="twitter-follow-button"' +
       ' data-button="grey" data-text-color="#FFFFFF" data-link-color="#00AEFF"'+
       ' data-show-count="false" data-lang="ru">' +
     "Читать @#{account}</a>").html_safe
  end

  def twitter_share
    account = 'insomnis_story'
    url     =  root_url

    if rand > 0.3
      text = 'Инсомнис — блог из другого мира. В отличии от книги ' +
             'вы можете общаться с героем прямо по ходу развития событий.'
    else
      text = '2028 год. Эпидемия пришла к людям и они потеряли надежду. ' +
             'Дьявол соблазняет людей и инквизиция карает невиновных.'
    end
    ('<a href="https://twitter.com/share"' +
       ' class="twitter-share-button"' +
       " data-url=\"#{url}\" data-text=\"#{text}\" data-related=\"#{account}\""+
       ' data-count="horizontal" data-lang="ru">' +
     'Твитнуть</a>').html_safe
  end

end
