const puppeteer = require('puppeteer-core');
const PuppeteerHar = require('puppeteer-har');
const { setTimeout } = require('timers/promises');

(async () => {
  const browser = await puppeteer.launch({
    headless: false,
    executablePath: '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
  });
  const page = await browser.newPage();
  const har = new PuppeteerHar(page);

  await har.start({ path: 'radiko.jp.har' });

  await page.goto('https://radiko.jp/#!/live/BAYFM78');
  await page.setViewport({width: 1080, height: 1024});

  await page.waitForSelector('.js-policy-accept', {visible: true});
  await page.locator('.js-policy-accept').click();

  await setTimeout(300);
  
  await page.waitForSelector('.play-radio', {visible: true});
  await page.locator('.play-radio').click();

  await page.waitForSelector('#male', {visible: true});
  await page.locator('#male').click();
  await page.$eval('.questionare-form_submit', el => el.removeAttribute('disabled'));
  await page.locator('.questionare-form_submit').click();

  await page.locator('.play-radio').click();

  await setTimeout(600000);

  await har.stop();

  await browser.close();
})();
