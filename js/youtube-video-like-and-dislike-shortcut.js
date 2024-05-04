// ==UserScript==
// @name         YouTube video rating shortcuts
// @namespace    http://tampermonkey.net/
// @version      2024-03-17
// @description  try to take over the world!
// @author       You
// @match        https://*.youtube.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=youtube.com
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    window.onload = async () => {
        const like = () => document.querySelector("#top-level-buttons-computed > segmented-like-dislike-button-view-model > yt-smartimation > div > div > like-button-view-model > toggle-button-view-model > button-view-model > button").click();
        const dislike = () => document.querySelector("#top-level-buttons-computed > segmented-like-dislike-button-view-model > yt-smartimation > div > div > dislike-button-view-model > toggle-button-view-model > button-view-model > button").click();

        window.addEventListener("keydown", (e) => {
            const key = e.key;
            if (key == "+") {
                like();
            } else if (key == "-") {
                dislike();
            }
        });
    }
})();
