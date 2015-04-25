/*
Copyright 2010, 2011 Chris Mear and Justin Riley

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

function is_defined(variable){
  return typeof(variable) == "undefined"
}

function is_string(input){
  return typeof(input)=='string';
}

function alert_key_value_pairs(map){
  for (var key in map) {
    alert([key, map[key]].join("\n\n"));
  }
}

function error(msg){
  alert("!!! ERROR - " + msg);
}

var GithubIssuesWidget = {};
GithubIssuesWidget.url = "https://api.github.com/repos/" + GITHUB_ISSUES_USER + "/" + GITHUB_ISSUES_REPO + "/issues?callback=?"
if(typeof window.GITHUB_ISSUES_LABELS != "undefined") {
  if(is_string(GITHUB_ISSUES_LABELS)) {
    GithubIssuesWidget.url += "&labels=" + GITHUB_ISSUES_LABELS;
  } else {
    error("GITHUB_ISSUES_LABELS must be a string, ignoring label filter");
  }
}
GithubIssuesWidget.go = function () {
  $('#github-issues-widget').append('<p class="loading">Loading...</p>');
  $.getJSON(this.url, function (data) {
    var list = $('<ul></ul>');
    $.each(data.data, function (issueIndex, issue) {
      var issueHtml = "<li>";
      issueHtml += '<a href="' + issue.html_url+ '">';
      issueHtml += issue.title;
      issueHtml += "</a>";
      var style = "";
      $.each(issue.labels, function (labelIndex, label) {
        style = 'background-color:#' + label.color + ';';
        if(label.color == "000000"){
          style = 'color: white;' + style;
        }
        issueHtml += '<span class="label" style="' + style + '">' + label.name + '</span>';
      });
      issueHtml += "</li>";
      list.append(issueHtml);
    });
    $('#github-issues-widget p.loading').remove();
    $('#github-issues-widget').append(list);
  });
};
GithubIssuesWidget.go();
