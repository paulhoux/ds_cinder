#ifndef _LAYOUT_BUILDER_APP_H_
#define _LAYOUT_BUILDER_APP_H_

#include <cinder/app/AppBasic.h>
#include <ds/app/app.h>

#include "app/globals.h"
#include "query/query_handler.h"
#include "ds/touch/touch_debug.h"

#include <ds/ui/layout/layout_sprite.h>

namespace layout_builder {
class AllData;

class layout_builder : public ds::App {
public:
	layout_builder();

	virtual void		mouseDown(ci::app::MouseEvent e);
	virtual void		mouseDrag(ci::app::MouseEvent e);
	virtual void		mouseUp(ci::app::MouseEvent e);
	virtual void		keyDown(ci::app::KeyEvent event);
	void				setupServer();
	void				update();

	virtual void		fileDrop(ci::app::FileDropEvent event);
private:
	typedef ds::App		inherited;

	void				loadLayout(const std::string& location);
	// Data
	AllData				mAllData;

	// Data acquisition
	Globals				mGlobals;
	QueryHandler		mQueryHandler;

	//Idle state of the app to detect state change
	bool				mIdling;


	ds::TouchDebug		mTouchDebug;

	ds::ui::LayoutSprite*	mController;


	void				moveCamera(const ci::Vec3f& deltaMove);
};

} // !namespace layout_builder

#endif // !_LAYOUT_BUILDER_APP_H_