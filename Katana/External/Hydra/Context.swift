/*
* Hydra
* Fullfeatured lightweight Promise & Await Library for Swift
*
* Created by:	Daniele Margutti
* Email:		hello@danielemargutti.com
* Web:			http://www.danielemargutti.com
* Twitter:		@danielemargutti
*
* Copyright © 2017 Daniele Margutti
*
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*/

import Foundation

//MARK: Context (GCD Wrapper)

/// Grand Central Dispatch Queues
/// This is essentially a wrapper around GCD Queues and allows you to specify a queue in which operation will be executed in.
///
/// More on GCD QoS info are available [here](https://developer.apple.com/library/content/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html).
///
/// - background: Should we used when work takes significant time, such as minutes or hours. Work is not visible to the user, such as indexing, synchronizing, and backups. Focuses on energy efficiency.
/// - main: The serial queue associated with the application’s main thread.
/// - userInteractive: Should we used when work is virtually instantaneous (work that is interacting with the user, such as operating on the main thread, refreshing the user interface, or performing animations. If the work doesn’t happen quickly, the user interface may appear frozen. Focuses on responsiveness and performance).
/// - userInitiated: Should we used when work is nearly instantaneous, such as a few seconds or less (work that the user has initiated and requires immediate results, such as opening a saved document or performing an action when the user clicks something in the user interface. The work is required in order to continue user interaction. Focuses on responsiveness and performance).
/// - utility: Should we used when work takes a few seconds to a few minutes (work that may take some time to complete and doesn’t require an immediate result, such as downloading or importing data. Utility tasks typically have a progress bar that is visible to the user. Focuses on providing a balance between responsiveness, performance, and energy efficiency).
/// - custom: provide a custom queue
public enum Context {
	case main
	case userInteractive
	case userInitiated
	case utility
	case background
	case custom(queue: DispatchQueue)
	
	public var queue: DispatchQueue {
		switch self {
			case .main: return .main
			case .userInteractive: return .global(qos: .userInteractive)
			case .userInitiated: return .global(qos: .userInitiated)
			case .utility: return .global(qos: .utility)
			case .background: return .global(qos: .background)
			case .custom(let queue): return queue
		}
	}
}

