# encoding: utf-8
module SocialHelper

  def twitter_subscribe(account)
    ("<a href=\"https://twitter.com/#{account}\"" +
       ' class="twitter-follow-button"' +
       ' data-button="grey" data-text-color="#FFFFFF" data-link-color="#00AEFF"'+
       ' data-show-count="false" data-lang="ru">' +
     "Читать @#{account}</a>").html_safe
  end

  def twitter_share(account, url, text)
    ('<a href="https://twitter.com/share"' +
       ' class="twitter-share-button"' +
       " data-url=\"#{url}\" data-text=\"#{text}\" data-related=\"#{account}\""+
       ' data-count="horizontal" data-lang="ru">' +
     'Твитнуть</a>').html_safe
  end

end
