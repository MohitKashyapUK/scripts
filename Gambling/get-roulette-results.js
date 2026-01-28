let top_results = "";
let bottom_results = "";

let results = document.querySelector(top_results).innerText.replaceAll("\n", " ") + " " + document.querySelector(bottom_results).innerText.replaceAll("\n", " ")

results.split(" ").reverse().join(" ");
