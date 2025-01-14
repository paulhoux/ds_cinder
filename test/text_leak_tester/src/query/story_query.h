#pragma  once
#ifndef _TEXT_LEAK_TESTER_APP_QUERY_STORY_QUERY_H_
#define _TEXT_LEAK_TESTER_APP_QUERY_STORY_QUERY_H_

#include <functional>
#include <Poco/Runnable.h>
#include <ds/query/query_result.h>

#include "model/all_data.h"

namespace downstream {

/**
 * \class downstream::StoryQuery
 */
class StoryQuery : public Poco::Runnable {
public:
	StoryQuery();

	virtual void			run();

	AllData					mOutput;

private:
	void					query(AllData& output);
};

} // !namespace downstream

#endif //!_TEXT_LEAK_TESTER_APP_QUERY_INDUSTRY_QUERY_H_
