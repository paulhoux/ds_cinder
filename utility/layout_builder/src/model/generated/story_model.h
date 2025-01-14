#ifndef _LAYOUT_BUILDER_APP_DS_MODEL_AUTOGENERATED_Story
#define _LAYOUT_BUILDER_APP_DS_MODEL_AUTOGENERATED_Story

#include <ds/data/resource.h>
#include <memory>
#include <vector>
#include <cinder/Vector.h>



namespace ds {
namespace model{



/**
* \class ds::model::StoryRef
*			Auto-generated data model for Story
*/
class StoryRef {
public:

	StoryRef();

	const unsigned int& getId() const;
	const std::wstring& getName() const;
	const int& getFilterableId() const;


	StoryRef& setId(const unsigned int& Id);
	StoryRef& setName(const std::wstring& Name);
	StoryRef& setFilterableId(const int& FilterableId);



private:
	class Data;
	std::shared_ptr<Data>	mData;
};

} // !namespace model
} // !namespace ds

#endif // !_LAYOUT_BUILDER_APP_DS_MODEL_AUTOGENERATED_Story