#include "scroll_list.h"

#include <ds/ui/sprite/sprite_engine.h>
#include <ds/ui/scroll/scroll_area.h>
#include <ds/debug/logger.h>

namespace ds{
namespace ui{

ScrollList::ScrollList(ds::ui::SpriteEngine& engine, const bool vertical)
	: ds::ui::Sprite(engine)
	, mScrollArea(nullptr)
	, mStartPositionY(10.0f)
	, mStartPositionX(10.0f)
	, mIncrementAmount(50.0f)
	, mAnimateOnDeltaDelay(0.0f)
	, mAnimateOnStartDelay(0.0f)
	, mVerticalScrolling(vertical)
{
	mScrollArea = new ds::ui::ScrollArea(mEngine, getWidth(), getHeight(), mVerticalScrolling);
	if(mScrollArea){
		mScrollArea->setScrollUpdatedCallback([this](ds::ui::Sprite*){ assignItems(); });
		mScrollArea->setFadeColors(ci::ColorA(0.0f, 0.0f, 0.0f, 1.0f), ci::ColorA(0.0f, 0.0f, 0.0f, 0.0f));
		mScrollArea->setFadeHeight(50.0f);
		mScrollArea->setUseFades(true);
		addChildPtr(mScrollArea);
	}

	mScrollableHolder = new ds::ui::Sprite(mEngine);

	if(mScrollableHolder){
		mScrollArea->addSpriteToScroll(mScrollableHolder);
		mScrollableHolder->enable(false);
	}

	enable(false);
}

void ScrollList::setContent(const std::vector<int>& models){
	clearItems();

	for(auto it = models.begin(); it < models.end(); ++it){
		mItemPlaceHolders.push_back(ItemPlaceHolder((*it)));
	}

	layout();
	animateItemsOn();
}

void ScrollList::animateItemsOn(){
	float theDelay = mAnimateOnStartDelay;
	for(auto it = mItemPlaceHolders.begin(), it2 = mItemPlaceHolders.end(); it != it2; ++it){
		if((*it).mAssociatedSprite){
			if(mAnimateOnCallback) mAnimateOnCallback((*it).mAssociatedSprite, theDelay);
			theDelay += mAnimateOnDeltaDelay;
		}
	}
}

void ScrollList::layout(){

	layoutItems();


	if(mVerticalScrolling){
		float scrollyHeight = mScrollableHolder->getHeight();

		if(scrollyHeight < getHeight()){
			scrollyHeight = getHeight();
		}

		if(mScrollableHolder){
			mScrollableHolder->setSize(getWidth(), scrollyHeight);
		}
	} else {
		float scrollyWidth = mScrollableHolder->getWidth();

		if(scrollyWidth < getWidth()){
			scrollyWidth = getWidth();
		}

		if(mScrollableHolder){
			mScrollableHolder->setSize(scrollyWidth, getHeight());
		}
	}

	if(mScrollArea){
		mScrollArea->setScrollSize(getWidth(), getHeight());
	}

	assignItems();
}


// Override if you need to do something special with the layout, otherwise just set start positions and increment amounts
void ScrollList::layoutItems(){

	float xp = mStartPositionX;
	float yp = mStartPositionY;

	for(auto it = mItemPlaceHolders.begin(); it < mItemPlaceHolders.end(); ++it){
		(*it).mX = xp;
		(*it).mY = yp;

		if(mVerticalScrolling){
			yp += mIncrementAmount;
		} else {
			xp += mIncrementAmount;
		}
	}

	if(mVerticalScrolling){
		mScrollableHolder->setSize(getWidth(), yp);
	} else {
		mScrollableHolder->setSize(xp, getHeight());
	}
}


void ScrollList::clearItems(){
	for(auto it = mItemPlaceHolders.begin(), it2 = mItemPlaceHolders.end(); it != it2; ++it){
		if(it->mAssociatedSprite){
			it->mAssociatedSprite->hide();
			mReserveItems.push_back(it->mAssociatedSprite);
		}
	}

	mItemPlaceHolders.clear();

	if(mScrollArea){
		mScrollArea->setScrollSize(mScrollArea->getWidth(), mScrollArea->getHeight());
	}
}

void ScrollList::assignItems(){
	if(!mScrollArea || !mScrollableHolder) return;

	float y = mScrollArea->getScrollerPosition().y;
	float x = mScrollArea->getScrollerPosition().x;
	float scrollHeight = mScrollArea->getHeight();
	float scrollWidth = mScrollArea->getWidth();


	std::vector<int> needsSprite;

	// Look through all the placeholdser and find all the items that should be onscreen
	// push the offscreen sprites into the reserve vector
	for(auto it = mItemPlaceHolders.begin(), it2 = mItemPlaceHolders.end(); it != it2; ++it){
		float itemY = y + it->mY;
		float itemX = x + it->mX;

		if((mVerticalScrolling && ((itemY + mIncrementAmount > 0.0f) && (itemY < scrollHeight))) ||
			(!mVerticalScrolling && ((itemX + mIncrementAmount > 0.0f) && (itemX < scrollWidth)))
			){
			if(it->mAssociatedSprite){
				it->mAssociatedSprite->setPosition(it->mX, it->mY);
			} else {
				needsSprite.push_back(it - mItemPlaceHolders.begin());
			}
		} else {
			if(it->mAssociatedSprite){
				mReserveItems.push_back(it->mAssociatedSprite);
			}
			it->mAssociatedSprite = nullptr;
		}
	}

	// give all the placeholders that need a sprite
	for(auto it = needsSprite.begin(), it2 = needsSprite.end(); it != it2; ++it){
		ds::ui::Sprite* sprite = nullptr;
		if(!mReserveItems.empty()){
			sprite = mReserveItems.back();
			mReserveItems.pop_back();
		} else {
			if(mCreateItemCallback) sprite = mCreateItemCallback();
			if(sprite){
				sprite->setProcessTouchCallback([this](ds::ui::Sprite* sp, const ds::ui::TouchInfo& ti){ handleItemTouchInfo(sp, ti); });
				sprite->setTapCallback([this, sprite](ds::ui::Sprite* bs, const ci::Vec3f cent){
					if(mItemTappedCallback) mItemTappedCallback(sprite, cent);
				});
				mScrollableHolder->addChildPtr(sprite);
			} else {
				DS_LOG_WARNING("Didn't create a sprite for scroll list! Use the callback and make sprites when we need them!!");
			}
		}

		auto &placeHolder = mItemPlaceHolders[*it];

		if(sprite){

			if(mSetDataCallback) mSetDataCallback(sprite, placeHolder.mDbId);
			sprite->setPosition(placeHolder.mX, placeHolder.mY);
			sprite->show();
			placeHolder.mAssociatedSprite = sprite;
		}
	}

	// hide any extras
	for(auto it = mReserveItems.begin(), it2 = mReserveItems.end(); it != it2; ++it){
		auto sprite = *it;
		sprite->hide();
	}

}

void ScrollList::handleItemTouchInfo(ds::ui::Sprite* bs, const TouchInfo& ti){
	if(bs){
		if(mStateChangeCallback) mStateChangeCallback(bs, ti.mNumberFingers > 0);

		if(mScrollArea  && ti.mPhase == ds::ui::TouchInfo::Moved && ti.mCurrentGlobalPoint.distance(ti.mStartPoint) > mEngine.getMinTapDistance()){
			if(mStateChangeCallback) mStateChangeCallback(bs, false);
			bs->passTouchToSprite(mScrollArea->getSpriteToPassTo(), ti);
			return;
		}
	}
}

void ScrollList::onSizeChanged(){
	layout();
}

void ScrollList::setItemTappedCallback(const std::function<void(ds::ui::Sprite*, const ci::Vec3f& cent)> &func){
	mItemTappedCallback = func;
}

void ScrollList::setCreateItemCallback(const std::function<ds::ui::Sprite*() > &func){
	mCreateItemCallback = func;
}

void ScrollList::setDataCallback(const std::function<void(ds::ui::Sprite*, const int dbId) > &func){
	mSetDataCallback = func;
}

void ScrollList::setAnimateOnCallback(const std::function<void(ds::ui::Sprite*, const float delay)>&func){
	mAnimateOnCallback = func;
}

void ScrollList::setStateChangeCallback(const std::function<void(ds::ui::Sprite*, const bool highlighted)>&func){
	mStateChangeCallback = func;
}

void ScrollList::setLayoutParams(const float startPositionX, const float startPositionY, const float incremenetAmount){
	mStartPositionX = startPositionX;
	mStartPositionY = startPositionY;
	mIncrementAmount = incremenetAmount;
}

}
}