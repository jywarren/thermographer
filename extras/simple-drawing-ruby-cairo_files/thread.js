/*jslint evil:true */
/**
 * Dynamic thread loader
 *
 * 
 * 
 * 
 * 
*/

// 
var DISQUS;
if (!DISQUS || typeof DISQUS == 'function') {
    throw "DISQUS object is not initialized";
}
// 

// json_data and default_json django template variables will close
// and re-open javascript comment tags

(function () {
    var jsonData, cookieMessages, session;

    /* */ jsonData = {"reactions": [], "has_more_reactions": false, "users": {}, "forum": {"use_media": false, "avatar_size": 32, "mobile_theme_disabled": false, "is_early_adopter": false, "login_buttons_enabled": false, "streaming_realtime": false, "reply_position": true, "default_avatar_url": "http://mediacdn.disqus.com/1289542154/images/noavatar32.png", "template": {"mobile": {"url": "http://mediacdn.disqus.com/1289542154/build/themes/newmobile.js", "css": "http://mediacdn.disqus.com/1289542154/build/themes/newmobile.css"}, "url": "http://mediacdn.disqus.com/1289542154/build/themes/narcissus.js?1289542347", "name": "Narcissus", "css": "http://mediacdn.disqus.com/1289542154/build/themes/narcissus.css?1289542347"}, "max_depth": 0, "linkbacks_enabled": true, "allow_anon_votes": true, "revert_new_login_flow": false, "show_avatar": true, "reactions_enabled": true, "disqus_auth_disabled": false, "name": "Vidar Hokstad V2.0", "language": "en", "url": "hokstad", "allow_anon_post": true, "thread_votes_disabled": false, "moderate_all": false}, "realtime_enabled": false, "request": {"sort": 2, "has_unmerged_users": false, "is_authenticated": false, "subscribe_on_post": 0, "missing_perm": null, "remote_domain_name": "", "remote_domain": "", "is_verified": false, "email": "", "profile_url": "", "username": "", "is_global_moderator": false, "sharing": {}, "timestamp": "2010-11-14_20:00:08", "is_moderator": false, "forum": "hokstad", "is_initial_load": true, "display_username": "", "points": null, "moderator_can_edit": false, "is_remote": false, "userkey": "", "page": 1}, "ordered_posts": [], "realtime_paused": false, "posts": {}, "integration": {"receiver_url": "", "hide_user_votes": false, "reply_position": true, "disqus_logo": false}, "thread": {"voters_count": 0, "offset_posts": 0, "slug": "simple_drawing_in_ruby_with_cairo", "paginate": false, "num_pages": 1, "days_alive": 0, "moderate_none": false, "voters": {}, "total_posts": 0, "realtime_paused": true, "queued": false, "pagination_type": "append", "user_vote": null, "likes": 0, "num_posts": 0, "closed": false, "per_page": 0, "id": 18204031, "killed": false, "moderate_all": false}, "reactions_limit": 10, "context": {"show_reply": true, "use_fb_connect": false, "active_switches": ["slim_paginator", "new_importer", "community_icon", "show_captcha_on_links"], "forum_facebook_key": "", "use_yahoo": false, "subscribed": false, "use_twitter_signin": true, "use_openid": false, "realtime_speed": 15000, "switches": {"overview_trending_threads": false, "easy_xdm": false, "bespin": false, "slim_paginator": true, "show_captcha_on_links": true, "debug_js": false, "ssl_auth": false, "embed_sdk_loader": false, "ssl": false, "new_importer": true, "community_icon": true, "v4_templates": false, "auto_blacklist_spammers": false, "enable_random_recommendations": false}}, "ready": true, "mediaembed": [], "reactions_start": 0, "settings": {"read_only": false, "realtime_url": "http://disqus.com/forums/realtime.js", "minify_js": true, "debug": false, "disqus_url": "http://disqus.com", "uploads_url": "http://media.disqus.com/uploads", "recaptcha_public_key": "6LdKMrwSAAAAAPPLVhQE9LPRW4LUSZb810_iaa8u", "media_url": "http://mediacdn.disqus.com/1289542154"}, "media_url": "http://mediacdn.disqus.com/1289542154"}; /* */
    /* */ cookieMessages = {"user_created": null, "post_has_profile": null, "post_twitter": null, "post_not_approved": null}; session = {"url": null, "name": null, "email": null}; /* */

    DISQUS.jsonData = jsonData;
    DISQUS.jsonData.cookie_messages = cookieMessages;
    DISQUS.jsonData.session = session;

    DISQUS.lang.extend(DISQUS.settings, DISQUS.jsonData.settings);
}());

DISQUS.jsonData.context.csrf_token = '21bc467119200cb06806902fa8e2f5b0';

DISQUS.jsonData.urls = {
    login: 'http://disqus.com/profile/login/',
    logout: 'http://disqus.com/logout/',
    reply: 'http://hokstad.disqus.com/thread/simple_drawing_in_ruby_with_cairo/reply.html',
    stats: 'http://hokstad.disqus.com/stats.html',
    edit: 'http://hokstad.disqus.com/embed/editcomment.html',
    embed_edit: 'http://disqus.com/embed/edit.html',
    request_user_profile: 'http://disqus.com/AnonymousUser/',
    request_user_avatar: 'http://mediacdn.disqus.com/1289542154/images/noavatar92.png',
    verify_email: 'http://disqus.com/verify/',
    remote_settings: 'http://hokstad.disqus.com/_auth/embed/remote_settings/',
    embed_thread: 'http://hokstad.disqus.com/thread.js',
    embed_profile: 'http://disqus.com/embed/profile.js',
    embed_vote: 'http://hokstad.disqus.com/vote.js',
    embed_thread_vote: 'http://hokstad.disqus.com/thread_vote.js',
    embed_thread_share: 'http://hokstad.disqus.com/thread_share.js',
    embed_login: 'http://disqus.com/embed/login.html',
    embed_report: 'http://hokstad.disqus.com/thread/simple_drawing_in_ruby_with_cairo/post_report/',
    embed_queueurl: 'http://hokstad.disqus.com/queueurl.js',
    embed_hidereaction: 'http://hokstad.disqus.com/hidereaction.js',
    embed_more_reactions: 'http://hokstad.disqus.com/more_reactions.js',
    embed_subscribe: 'http://hokstad.disqus.com/subscribe.js',
    embed_highlight: 'http://hokstad.disqus.com/highlight.js',
    embed_kill: 'http://hokstad.disqus.com/kill.js',
    embed_block: 'http://hokstad.disqus.com/block.js',
    toggle_thread_killed: 'http://hokstad.disqus.com/toggle_thread_killed.js',
    toggle_thread_closed: 'http://hokstad.disqus.com/toggle_thread_closed.js',
    update_moderate_all: 'http://hokstad.disqus.com/update_moderate_all.js',
    update_days_alive: 'http://hokstad.disqus.com/update_days_alive.js',
    show_user_votes: 'http://hokstad.disqus.com/show_user_votes.js',
    report_spam: 'http://hokstad.disqus.com/reportspam.js',
    forum_view: 'http://hokstad.disqus.com/simple_drawing_in_ruby_with_cairo',
    get_comment_message: 'http://hokstad.disqus.com/get_comment_message.js',
    cnn_saml_try: 'http://disqus.com/saml/cnn/try/',
    realtime: DISQUS.jsonData.settings.realtime_url,
    thread_view: 'http://hokstad.disqus.com/thread/simple_drawing_in_ruby_with_cairo/',
    twitter_connect: DISQUS.jsonData.settings.disqus_url + '/_ax/twitter/begin/',
    yahoo_connect: DISQUS.jsonData.settings.disqus_url + '/_ax/yahoo/begin/',
    openid_connect: DISQUS.jsonData.settings.disqus_url + '/_ax/openid/begin/',
    tweetbox_frame: 'http://disqus.com/forums/integrations/twitter/tweetbox.html',
    community: 'http://hokstad.disqus.com/community.html',
    admin: 'http://hokstad.disqus.com/admin/moderate/',
    moderate: 'http://hokstad.disqus.com/admin/moderate/',
    moderate_threads: 'http://hokstad.disqus.com/admin/moderate-threads/',
    settings: 'http://hokstad.disqus.com/admin/settings/',
    embedFbAuth: 'http://disqus.com/forums/hokstad/fbauth.html',
    embedSsoAuth: 'http://disqus.com/forums/hokstad/sso_auth_frame.html',
    unmerged_profiles: 'http://disqus.com/embed/profile/unmerged_profiles/'
};
