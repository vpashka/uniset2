#include <string>
#include <iostream>
#include <assert.h>
#include <thread>
#include <atomic>
#include "UMessageQueue.h"
// --------------------------------------------------------------------------
using namespace std;
using namespace UniSetTypes;
// --------------------------------------------------------------------------
UMessageQueue mq; // тестируемая очередь

const size_t COUNT = 1000000; // сколько сообщения послать
// --------------------------------------------------------------------------
// поток записи
void mq_write_thread()
{
	SensorMessage smsg(100,2);
	TransportMessage tm( std::move(smsg.transport_msg()) );
	auto vm = make_shared<VoidMessage>(tm);

	msleep(100);

	for( size_t i=0; i<COUNT; i++ )
	{
		mq.push(vm);
	}
}
// --------------------------------------------------------------------------
int one_test()
{
	auto wthread = std::thread(mq_write_thread);

	std::chrono::time_point<std::chrono::system_clock> start, end;
	start = std::chrono::system_clock::now();

	size_t rnum = 0;

	while( rnum < COUNT )
	{
		auto m = mq.top();
		if( m )
			rnum++;
	}

	wthread.join();

	end = std::chrono::system_clock::now();
	return std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
}
// --------------------------------------------------------------------------
int main(int argc, const char** argv)
{
	try
	{
		uniset_init(argc, argv);

		int tnum = 10;

		// чтобы не происходило переполнение
		mq.setMaxSizeOfMessageQueue(COUNT+1);

		// сперва просто проверка что очередь работает.
		{
			SensorMessage sm(100,2);
			TransportMessage tm( std::move(sm.transport_msg()) );
			auto vm = make_shared<VoidMessage>(tm);
			mq.push(vm);
			auto msg = mq.top();
			assert( msg!=nullptr );
			SensorMessage sm2( msg.get() );
			assert( sm.id == sm2.id );
		}

		vector<int> res;
		res.reserve(tnum);

		for( int i=0; i<tnum; i++ )
		{
			res.push_back(one_test());
		}

		// вычисляем среднее
		int sum = 0;
		for( auto&& r: res )
			sum += r;

		float avg = (float)sum / tnum;

		std::cerr << "average elapsed time [" << tnum << "]: " << avg << " msec for " << COUNT << endl;

		return 0;
	}
	catch( const SystemError& err )
	{
		cerr << "(mq-test): " << err << endl;
	}
	catch( const Exception& ex )
	{
		cerr << "(mq-test): " << ex << endl;
	}
	catch( const std::exception& e )
	{
		cerr << "(mq-test): " << e.what() << endl;
	}
	catch(...)
	{
		cerr << "(mq-test): catch(...)" << endl;
	}

	return 1;
}