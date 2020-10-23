const puppeteer = require("puppeteer");

(async () => {
  const browser = await puppeteer.launch({headless: false, slowMo: 15});
  const page = await browser.newPage();

  await page.setViewport({ width: 1280, height: 800 })

  await page.goto(process.env.TARGET_URL);

  await page.waitForSelector("a[href='/pricing']");
  await page.click("a[href='/pricing']");

  await page.waitForSelector(".price-block", { visible: true })

  await browser.close();
})();
