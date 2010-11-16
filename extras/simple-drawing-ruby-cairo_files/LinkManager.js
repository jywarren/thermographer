
function LinkManager() { }
LinkManager._path = '/links/dwr';

LinkManager.getLinkById = function(p0, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'getLinkById', p0, callback);
}

LinkManager.setLinkStatus = function(p0, p1, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'setLinkStatus', p0, p1, false, callback);
}

LinkManager.getRemoteLinksByStatus = function(p0, p1, p2, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'getRemoteLinksByStatus', p0, p1, p2, false, callback);
}

LinkManager.incrementVoteCount = function(p0, p1, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'incrementVoteCount', p0, p1, false, callback);
}

LinkManager.decrementVoteCount = function(p0, p1, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'decrementVoteCount', p0, p1, false, callback);
}

LinkManager.getRemoteTopLinksByNumDays = function(p0, p1, p2, p3, p4, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'getRemoteTopLinksByNumDays', p0, p1, p2, p3, p4, callback);
}

LinkManager.checkDuplicates = function(p0, p1, p2, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'checkDuplicates', p0, p1, p2, callback);
}

LinkManager.storePreviousURL = function(p0, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'storePreviousURL', p0, false, callback);
}

LinkManager.markSharedLink = function(p0, p1, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'markSharedLink', p0, p1, false, callback);
}

LinkManager.setLinkAsUserFavorite = function(p0, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'setLinkAsUserFavorite', p0, false, callback);
}

LinkManager.setLinkAsUserFavorite = function(p0, p1, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'setLinkAsUserFavorite', p0, p1, false, callback);
}

LinkManager.unsetLinkAsUserFavorite = function(p0, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'unsetLinkAsUserFavorite', p0, false, callback);
}

LinkManager.setPersonalTagsForUserAndLink = function(p0, p1, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'setPersonalTagsForUserAndLink', p0, p1, false, callback);
}

LinkManager.setModerated = function(p0, p1, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'setModerated', p0, p1, false, callback);
}

LinkManager.addWatchForLink = function(p0, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'addWatchForLink', p0, callback);
}

LinkManager.removeWatch = function(p0, callback) {
    DWREngine._execute(LinkManager._path, 'LinkManager', 'removeWatch', p0, callback);
}
