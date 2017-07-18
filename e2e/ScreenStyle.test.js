const Utils = require('./Utils');
const elementByLabel = Utils.elementByLabel;

describe('screen style', () => {
  beforeEach(async () => {
    await device.relaunchApp();
  });

  it('declare a navigationOptions on container component', async () => {
    await elementByLabel('Push Options Screen').tap();
    await expect(element(by.label('Static Title').and(by.type('UILabel')))).toBeVisible();
  });

  it('change title on container component', async () => {
    await elementByLabel('Push Options Screen').tap();
    await expect(element(by.label('Static Title').and(by.type('UILabel')))).toBeVisible();
    await elementByLabel('Dynamic Options').tap();
    await expect(element(by.label('Dynamic Title').and(by.type('UILabel')))).toBeVisible();
  });

  it('set dynamic options with valid options will do something and not crash', async () => {
    // we have no way of testing individual styles for the screen
    await elementByLabel('Push Options Screen').tap();
    await elementByLabel('Dynamic Options').tap();
    await expect(element(by.label('Options Screen'))).toBeVisible();
  });

  
  it('hides topBar when topBarHidden is set to true, and shows it when topBarHidden is set to false', async () => {
    await elementByLabel('Push Options Screen').tap();
    await elementByLabel('setTopBarHidden').tap();
    await expect(element(by.type('UINavigationBar'))).toBeNotVisible()
    await elementByLabel('Dynamic Options').tap();
    await expect(element(by.type('UINavigationBar'))).toBeVisible()
  })

  it('hides topBar on scroll when topBarHideOnScroll is set to true', async () => {
    await elementByLabel('Push Options Screen').tap();
    await elementByLabel('ScrollView Screen').tap();
    await expect(element(by.type('UINavigationBar'))).toBeVisible();
    await element(by.id('scrollView')).swipe('up', 'fast');
    await expect(element(by.type('UINavigationBar'))).toBeNotVisible();
    await element(by.id('scrollView')).swipe('down', 'fast');
    await expect(element(by.type('UINavigationBar'))).toBeVisible();
  })
});
