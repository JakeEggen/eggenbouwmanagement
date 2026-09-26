const MEASUREMENT_ID = "G-VCVRFCRHFE"
const STORAGE_KEY = "eggen_analytics_consent"

function consent() {
  try {
    return localStorage.getItem(STORAGE_KEY)
  } catch {
    return null
  }
}

function storeConsent(value) {
  try {
    localStorage.setItem(STORAGE_KEY, value)
  } catch {
    // Private mode can block storage; the choice then lasts for this page only.
  }
}

function banner() {
  return document.getElementById("cookie-banner")
}

function showBanner() {
  banner()?.removeAttribute("hidden")
}

function hideBanner() {
  banner()?.setAttribute("hidden", "")
}

function enableAnalytics() {
  if (window.gtag) {
    window.gtag("consent", "update", { analytics_storage: "granted" })
    return
  }

  window.dataLayer = window.dataLayer || []
  window.gtag = function () {
    window.dataLayer.push(arguments)
  }
  window.gtag("consent", "default", {
    analytics_storage: "denied",
    ad_storage: "denied",
    ad_user_data: "denied",
    ad_personalization: "denied"
  })
  window.gtag("js", new Date())
  window.gtag("config", MEASUREMENT_ID, { send_page_view: false })
  window.gtag("consent", "update", { analytics_storage: "granted" })

  const script = document.createElement("script")
  script.async = true
  script.src = `https://www.googletagmanager.com/gtag/js?id=${MEASUREMENT_ID}`
  document.head.appendChild(script)
}

function trackPageView() {
  if (consent() !== "granted" || typeof window.gtag !== "function") return

  window.gtag("event", "page_view", {
    page_location: window.location.href,
    page_title: document.title
  })
}

function clearAnalyticsCookies() {
  const hostname = window.location.hostname
  document.cookie.split(";").forEach((part) => {
    const name = part.split("=")[0].trim()
    if (!name.startsWith("_ga")) return

    const expiry = `${name}=; Max-Age=0; path=/`
    document.cookie = expiry
    document.cookie = `${expiry}; domain=${hostname}`
    document.cookie = `${expiry}; domain=.${hostname}`
  })
}

function denyAnalytics() {
  storeConsent("denied")
  hideBanner()
  clearAnalyticsCookies()

  if (typeof window.gtag === "function") {
    window.gtag("consent", "update", { analytics_storage: "denied" })
  }
}

document.addEventListener("turbo:load", () => {
  if (consent() === "granted") {
    hideBanner()
    enableAnalytics()
    trackPageView()
  } else if (consent() === "denied") {
    hideBanner()
  } else {
    showBanner()
  }
})

document.addEventListener("click", (event) => {
  if (event.target.closest("[data-cookie-accept]")) {
    storeConsent("granted")
    hideBanner()
    enableAnalytics()
    trackPageView()
    return
  }

  if (event.target.closest("[data-cookie-decline]")) {
    denyAnalytics()
    return
  }

  if (event.target.closest("[data-cookie-settings]")) {
    showBanner()
  }
})
