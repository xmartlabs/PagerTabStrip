# Change Log

All notable changes to PagerTabStrip will be documented in this file.

### [4.1.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/4.1.0)

<!-- Released on 2024-10-17. -->

- Fix PagerTabStripView to make it work in iOS 18

### [4.0.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/4.0.0)

<!-- Released on 2023-02-02. -->

- Xcode 14+, iOS 16+ now is required.
- Clean up code by using Swift 5.7 capabilities. 
- `.pagerTabItem(tag: SelectionType)` modifier now requires tag parameter which identifies the pager tab item. 
- `pagerTabStripViewStyle(_ style: PagerStyle)` is the new modifier to set up pager style. 
- The Selection value indicating the selected page now supports any Hashable value, not just an Int as in the previous version.
- Improved the scroll behavior when the pager is added within another pager or scrollable container. When a child page reaches its edges, the parent scrollable container will scroll. Basically, we added a parameter to disable the edge scroll gesture to trigger the parent gesture.
- Added several complex examples to showcase new functionality.
- The scrollable style page now utilizes the iOS 16 native layout engine through the Layout protocol.
- Fixed the initial animation and position issue of the indicator when presenting the page.
- Resolved errors when reordering, adding, and deleting pages. Now it works perfectly.
- `public func onPageAppear(perform action: (() -> Void)?) -> some View` was removed. You should use onAppear native callback or use selection state variable.
- Refactored the enable/disable swipe gesture. Now it's a Binding parameter.
- `PagerTabViewDelegate` and `PagerTabViewState` deleted. You should use `selection` state or `pagerSettings.transition.progress(for: tag)` to get a notification on selection and scroll progress changes. 


### [3.2.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/3.2.0)

<!-- Released on 2022-03-11. -->

- Add support for custom style

### [3.1.1](https://github.com/xmartlabs/PagerTabStrip/releases/tag/3.1.1)

<!-- Released on 2021-12-20. -->

- Fix swipe back gesture

### [3.1.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/3.1.0)

<!-- Released on 2021-12-09. -->

- Disable swipe gesture support
- Bug fixes

### [3.0.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/3.0.0)

<!-- Released on 2021-10-05. -->

- Add scrollable style
- Bug fixes

### [2.1.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/2.1.0)

<!-- Released on 2021-10-05. -->

- Support for Xcode 13
- Bug fixes

### [2.0.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/2.0.0)

<!-- Released on 2021-08-18. -->

- Add segmented and bar style
- Bug fixes

### [1.0.0](https://github.com/xmartlabs/PagerTabStrip/releases/tag/1.0.0)

<!-- Released on 2020-01-20. -->

- This is the initial version.

[xmartlabs]: https://xmartlabs.com
