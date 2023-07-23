import { NativeModules, processColor } from 'react-native';
const { RNSfActionSheet } = NativeModules;

/**
 * Display action sheets on IOS.
 */
const SfActionSheet = {
	showActionSheetWithOptions(props = { options: [] }, callback = () => { }) {
		if (props.options) {
			props.options = props.options.map(opt => {
				const titleTextColor = processColor(opt.titleTextColor);
				if (opt.icon) {
					if (opt.icon.color) {
						opt.icon.color = processColor(opt.icon.color)
					}
					if (!opt.icon.size) {
						opt.icon.size = 24
					}
					if (!opt.icon.resizeMode) {
						opt.icon.resizeMode = 'center'
					}
				}
				return { ...opt, titleTextColor };
			})
		}
		const tintColor = processColor(props.tintColor)
		RNSfActionSheet.showActionSheetWithOptions({ ...props, tintColor }, callback);
	}
};

module.exports = SfActionSheet;
