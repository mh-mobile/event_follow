document.addEventListener("DOMContentLoaded", () => {
  const profile_icon = document.getElementById("js-profile");
  if (profile_icon) {
    const profile_setting = document.getElementById("js-profile-setting");
    document.addEventListener(
      "click",
      function (event) {
        const target = event.target;
        if (target.closest(".profile_icon")) {
          if (profile_setting.style.display === "block") {
            profile_setting.style.display = "none"
          } else {
            profile_setting.style.display = "block"
          } 
        } else if (!target.closest(".profile_setting")) {
            profile_setting.style.display = "none"
        }
      },
      false
    );    
  }
});

