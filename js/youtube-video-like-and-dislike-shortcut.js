// ==UserScript==
// @name         Give YouTube videos rating by shortcuts
// @namespace    http://tampermonkey.net/
// @version      2024-03-17
// @description  try to take over the world!
// @author       Mohit
// @match        *://*.youtube.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=youtube.com
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    window.onload = () => {
        const qs = selector => document.querySelector(selector);
        const select = "like-button-view-model button";
        const like = () => qs(select).click();
        const dislike = () => qs("dis" + select).click();

        window.addEventListener("keydown", e => {
            const key = e.key;
            if (key == "+") {
                like();
            } else if (key == "-") {
                dislike();
            }
        });
    }
})();
