#pragma  once
#ifndef _LAYOUT_BUILDER_APP_GLOBALS_
#define _LAYOUT_BUILDER_APP_GLOBALS_

#include <ds/cfg/cfg_text.h>
#include <ds/cfg/settings.h>
#include <ds/ui/sprite/sprite_engine.h>

#include "model/all_data.h"

namespace ds {
namespace ui {
class SpriteEngine;
} // namespace ui
} // namespace ds

namespace layout_builder {

/**
 * \class layout_builder::Globals
 * \brief Global data for the app.
 */
class Globals {
public:
	Globals(ds::ui::SpriteEngine&, const AllData& d);

	ds::ui::SpriteEngine&			mEngine;

	const AllData&					mAllData;

	const float						getAnimDur();

	void							initialize();

	//Shortcuts
	ds::cfg::Settings&				getSettingsLayout();
	ds::cfg::Settings&				getSettings(const std::string& name);

private:

	float							mAnimationDuration;
};

} // !namespace layout_builder

#endif // !_LAYOUT_BUILDER_APP_GLOBALS_