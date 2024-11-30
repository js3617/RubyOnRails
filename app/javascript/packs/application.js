// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import navDropdownItems from "../data/navDropdownItems.js"

// Nav Dropdown Render
const navMenuLectureEl = document.querySelector("nav .menu .lecture")
navMenuLectureEl.append(createDropdown(navDropdownItems))

function createDropdown(items) {
  const ulEl = document.createElement("ul")
  ulEl.classList.add("dropdown")

  items.forEach(item => {
    if(item["separator"]) {
      ulEl.innerHTML += `<hr class="separator">`
    } else {
      const liEl = document.createElement("li")
      liEl.innerHTML += `<a href="javascript:void(0)">${item["top"]}</a>`

      if(item["sub"]) {
        liEl.append(createDropdown(item["sub"]))
      }

      ulEl.append(liEl)
    }
  })

  return ulEl;
}

// Hero Swiper
const heroCurrentIndexEl = document.querySelector(".hero .current-index")
let heroSwiper = new Swiper('.hero .swiper', {
  direction: 'horizontal',
  loop: true,
  slidesPerView: 1,

  autoplay: {
    disableOnInteraction: false,
    delay: 5000
  },

  navigation: {
    nextEl: '.hero-btn-next',
    prevEl: '.hero-btn-prev',
  },

  pagination: {
      el: '.hero .swiper-pagination-container .swiper-pagination',
      clickable: true,
      renderBullet: function (index) {
        return /* html */ `
          <span class="swiper-pagination-bullet hero-bullet hero-bullet${index+1}">${heroBulletNames[index]}</span>
        `
      },
  },
});

// Hero More Swiper
let heroMoreSwiper = new Swiper(".hero .swiper", {
  loop: true,

  pagination: {
    el: '.hero .hero-more .swiper-pagination',
    clickable: true,
    renderBullet: function (index) {
      return /* html */ `
        <span class="swiper-pagination-bullet hero-bullet hero-bullet${index+1}">${heroBulletNames[index]}</span>
      `
    },
  },
})

heroSwiper.controller.control = heroMoreSwiper
heroMoreSwiper.controller.control = heroSwiper

// Hero Swiper Player
const heroSwiperPlayerEl = document.querySelector(".hero .hero-btn-player")
const heroSwiperPlayerIconEl = heroSwiperPlayerEl.querySelector("i")
heroSwiperPlayerEl.addEventListener("click", () => {
  if(heroSwiperPlayerIconEl.classList.contains("fa-play")) {
    heroSwiperPlayerIconEl.classList.remove("fa-play")
    heroSwiperPlayerIconEl.classList.add("fa-pause")
    heroSwiper.autoplay.start();
  } else {
    heroSwiperPlayerIconEl.classList.add("fa-play")
    heroSwiperPlayerIconEl.classList.remove("fa-pause")
    heroSwiper.autoplay.stop();
  }
})

// Hero Swiper Pagination Bullet Slider
const heroPaginationContainerEl = document.querySelector(".hero .swiper-pagination-container")
const heroPaginationEl = heroPaginationContainerEl.querySelector(".swiper-pagination")
const heroBulletEls = heroPaginationEl.querySelectorAll(".swiper-pagination-bullet")
const heroLeftGradientEl = heroPaginationContainerEl.querySelector(".left-gradient")
const heroRightGradientEl = heroPaginationContainerEl.querySelector(".right-gradient")
heroSwiper.on("slideChange", () => {
  var heroSwiperIndex = heroSwiper.realIndex + 1
  heroCurrentIndexEl.textContent = heroSwiperIndex

  var heroPaginationContainerWidth = heroPaginationContainerEl.offsetWidth
  var heroPaginationWidth = heroPaginationEl.offsetWidth
  var heroBulletWidth = heroBulletEls[heroSwiperIndex-1].offsetWidth
  var heroBulletLeft = heroBulletEls[heroSwiperIndex-1].offsetLeft
  var heroBulletRight = heroPaginationWidth - heroBulletLeft - heroBulletWidth
  if(heroPaginationContainerWidth / 2 >= heroBulletLeft + heroBulletWidth / 2) {
    heroPaginationEl.style.transform = "translateX(0)"
  } else {
    if(heroPaginationContainerWidth / 2 < heroBulletRight + heroBulletWidth / 2) {
      heroPaginationEl.style.transform = `translateX(-${heroBulletLeft + heroBulletWidth / 2 - heroPaginationContainerWidth / 2}px)`
    } else {
      heroPaginationEl.style.transform = `translateX(-${heroPaginationWidth - heroPaginationContainerWidth}px)`
    }
  }

  if(heroPaginationContainerWidth / 2 >= heroBulletLeft + heroBulletWidth / 2) {
    heroLeftGradientEl.classList.remove("active")
  } else {
    heroLeftGradientEl.classList.add("active")
  }
  if(heroPaginationContainerWidth / 2 < heroBulletRight + heroBulletWidth / 2) {
    heroRightGradientEl.classList.add("active")
  } else {
    heroRightGradientEl.classList.remove("active")
  }
})

// Hero More Toggler 
const heroToggleBtnEl = document.querySelector(".hero .hero-more-toggler")
const heroMoreEl = document.querySelector(".hero .hero-more")
const heroMoreHideBtnEl = heroMoreEl.querySelector('.hero-more-hide-btn')

heroToggleBtnEl.addEventListener("click", () => {
  heroToggleBtnEl.classList.toggle("active")
  heroMoreEl.classList.toggle("show")
})
heroMoreHideBtnEl.addEventListener("click", () => {
  heroToggleBtnEl.classList.remove("active")
  heroMoreEl.classList.remove("show")
})

// Move Scroll If Searching Input Focus
const searchingInputEl = document.querySelector(".searching .search input")
searchingInputEl.addEventListener("click", () => {
  window.scrollTo(0, 385)
})

// New Curation Swiper
let newCurationSwiper = new Swiper('.new-curation .new-curation__swiper', {
  direction: 'horizontal',
  slidesPerView: 12,
  slidesPerGroup: 11,
  slidesOffsetAfter: 56,

  navigation: {
    nextEl: '.new-curation__next-btn',
    prevEl: '.new-curation__prev-btn',
  },

  disabledClass: 'swiper-button-disabled',
});

// Free Course Swiper
let freeCourseSwiper = new Swiper(".free-course .free-course__swiper", {
  direction: 'horizontal',
  slidesPerView: 5,
  spaceBetween: 6,
  slidesPerGroup: 5,

  navigation: {
    nextEl: '.free-course__next-btn',
    prevEl: '.free-course__prev-btn',
  },

  disabledClass: 'swiper-button-disabled',
})

// Welcome Course Swiper
let welcomeCourseSwiper = new Swiper (".welcome-course .welcome-course__swiper", {
  direction: 'horizontal',
  slidesPerView: 5,
  spaceBetween: 6,
  slidesPerGroup: 5,

  navigation: {
    nextEl: '.welcome-course__next-btn',
    prevEl: '.welcome-course__prev-btn',
  },

  disabledClass: 'swiper-button-disabled',
})

// Roadmap Swiper
let roadmapSwiper = new Swiper (".roadmap .roadmap__swiper", {
  direction: 'horizontal',
  slidesPerView: 4,
  spaceBetween: 20,
  slidesPerGroup: 4,

  navigation: {
    nextEl: '.roadmap__next-btn',
    prevEl: '.roadmap__prev-btn',
  },

  disabledClass: 'swiper-button-disabled',
})

// New Course Swiper
let newCourseSwiper = new Swiper (".new-course .new-course__swiper", {
  direction: 'horizontal',
  slidesPerView: 5,
  spaceBetween: 6,
  slidesPerGroup: 5,

  navigation: {
    nextEl: '.new-course__next-btn',
    prevEl: '.new-course__prev-btn',
  },

  disabledClass: 'swiper-button-disabled',
})

// Review Swiper
let reviewSwiper = new Swiper (".review__right .swiper", {
  direction: 'vertical',
  loop: true,
  slidesPerView: 3,
  spaceBetween: 20,
  mousewheel: true,
  speed: 800,
})

// Banner Swiper
let bannerSwiper = new Swiper (".banner .banner__swiper", {
  direction: 'horizontal',
  slidesPerView: 1,

  navigation: {
    nextEl: '.banner .swiper-next-btn',
    prevEl: '.banner .swiper-prev-btn',
  },

  pagination: {
    el: '.banner .banner__pagination',
    clickable: true,
  },

  disabledClass: 'swiper-button-disabled',
})

// Chat Toggler
const chatTogglerEl = document.querySelector(".chat .chat__toggler")
const chatWindowEl = document.querySelector(".chat .chat__window")
chatTogglerEl.addEventListener("click", () => {
  chatTogglerEl.classList.toggle("show")
  chatWindowEl.classList.toggle("show")
})
