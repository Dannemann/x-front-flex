package br.com.dannemann.gui.controller
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.messages.ErrorMessage;
	import mx.resources.ResourceManager;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import br.com.dannemann.gui.XFrontConfigurator;
	import br.com.dannemann.gui.bean.DBeanBlazeDS;
	import br.com.dannemann.gui.component.DNotificator;
	import br.com.dannemann.gui.domain.Msgs;
	import br.com.dannemann.gui.domain.StrConsts;

	public class BlazeDs
	{
		// BlazeDS errors:
		private static const ERR_Channel_Call_Failed:String = "Channel.Call.Failed";
		private static const ERR_Client_Error_MessageSend:String = "Client.Error.MessageSend";

		public var _mainCaller:UIComponent;

//		public var _servletMessagebrokerAmf:String = DFxGUIConstants._BLAZEDS_MESSAGEBROKER_AMF;
//		public var _channelID:String = DFxGUIConstants._BLAZEDS_CHANNEL_MY_AMF;
//		public var _channelURL:String = DFxGUIParameters._applicationURL + DFxGUIConstants._CHAR_FORWARD_SLASH + _servletMessagebrokerAmf;

		private const _executingCommands:Dictionary = new Dictionary();

		private var _delayedTimers:Dictionary;

		private static var _messageCounter:int;
		
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public interface:

		// TENHO QUE INFORMAR AQUI PQ EU TO SEM COLOCAR O -SERVICES COMO COMPILE ARGUMET?
		protected static const _amfChannel:AMFChannel = new AMFChannel("erpro-amf",  "http://localhost:8080/erpro-web/messagebroker/amf");
		protected static const _channelSet:ChannelSet = new ChannelSet();
		
		{
			_channelSet.addChannel(_amfChannel);
		}
		
		public var remoteObject:DBlazeDSRemoteObject = new DBlazeDSRemoteObject();
		
		
		
		
		
		
		
		
		
		
		
		
		
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:
		
		public var _destination:String;
		
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Constructor:
		
		public function BlazeDs(destination:String=null)
		{
			_destination = destination;
		}
		
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public:

		/**
		 * 
		 */
		public function invoke1(blazedsVo:Object):void
		{
			var resolvedDest:String = blazedsVo.destination;
			if (!resolvedDest)
				resolvedDest = _destination;
			if (!resolvedDest)
				resolvedDest = XFrontConfigurator._crudServiceDestination;

			const destination:String = resolvedDest;
			const operation:String = blazedsVo.operation;
			const args:Object = blazedsVo.args;
			const callbackSuccess:Function = blazedsVo.callbackSucess;
			const callbackFault:Function = blazedsVo.callbackFault;
			const caller:UIComponent = blazedsVo.caller;
			const delayTime:uint = blazedsVo.delayTime;
			
			invoke3(resolvedDest, operation, args, callbackSuccess, caller, callbackFault, delayTime);
		}
		
		/**
		 * 
		 */
		public function invoke2(
			operation:String,
			args:Object=null,
			callbackSuccess:Function=null,
			caller:UIComponent=null,
			callbackFault:Function=null,
			delayTime:uint=0
		):void
		{
			var resolvedDest:String = _destination;
			if (!resolvedDest)
				resolvedDest = XFrontConfigurator._crudServiceDestination;
			
			invoke3(resolvedDest, operation, args, callbackSuccess, caller, callbackFault, delayTime);
		}
		
		/**
		 * 
		 */
		public function invoke3(
			destination:String,
			operation:String,
			args:Object=null,
			callbackSuccess:Function=null,
			caller:UIComponent=null,
			callbackFault:Function=null,
			delayTime:uint=0
		):void
		{
			resolveCaller(caller);
			
			if (!caller)
				caller = _mainCaller;
			
			const dBeanBlazeDS:DBeanBlazeDS = new DBeanBlazeDS();
//			dBeanBlazeDS._pkgClassMethod = pkgClassMethod;
			dBeanBlazeDS._parameters = args;
			dBeanBlazeDS._caller = caller;
			dBeanBlazeDS._callbackSucess = callbackSuccess;
			dBeanBlazeDS._callbackFault = callbackFault;
			
			if (_executingCommands[caller])
				showInExecutionMessage();
			else
			{
				const remoteObject:DBlazeDSRemoteObject = new DBlazeDSRemoteObject();
				remoteObject._dBeanBlazeDS = dBeanBlazeDS;
				remoteObject.destination = destination;
				remoteObject.channelSet = _channelSet;
				remoteObject.addEventListener(ResultEvent.RESULT, doInvokeSuccess);
				remoteObject.addEventListener(FaultEvent.FAULT, invokeFault);
				remoteObject.initialized(null, (++_messageCounter).toString());
				
				
				
				
				
				
				if (caller)
					_executingCommands[caller] = remoteObject;
				
//				const parameters:Object = new Object();
//				parameters.pkgClassMethod = dBeanBlazeDS._pkgClassMethod;
//				parameters.parameters = dBeanBlazeDS._parameters;
				
				if (delayTime > 0)
				{
					const timer:Timer = new Timer(delayTime, 1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayTimeComplete);
					
					if (!_delayedTimers)
						_delayedTimers = new Dictionary();
					
					_delayedTimers[timer] = [ remoteObject, args ];
					
					timer.start();
				}
				else
					remoteObject.getOperation(operation).send(args);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function invokeOld(
			destination:String,
			parameters:Object=null,
			callbackSucess:Function=null,
			caller:UIComponent=null,
			callbackFault:Function=null,
			delayTime:int=0
		):void
		{
//			if (parameters)
//				if (parameters.hasOwnProperty("_enterprise") && parameters._enterprise)
//					if (parameters.hasOwnProperty("_entityBeanClassName") && parameters._entityBeanClassName && String(parameters._entityBeanClassName).indexOf("br.com.dannemann.das") == 0)
//						parameters._enterprise = "DAS";

			resolveCaller(caller);

			if (!caller)
				caller = _mainCaller;

			const dBeanBlazeDS:DBeanBlazeDS = new DBeanBlazeDS();
//			dBeanBlazeDS._pkgClassMethod = pkgClassMethod;
			dBeanBlazeDS._parameters = parameters;
			dBeanBlazeDS._caller = caller;
			dBeanBlazeDS._callbackSucess = callbackSucess;
			dBeanBlazeDS._callbackFault = callbackFault;

			if (_executingCommands[caller])
				showInExecutionMessage();
			else
			{
//				public static const _BLAZEDS_MESSAGEBROKER_AMF:String = "messagebroker/amf";
//				public static const _BLAZEDS_CHANNEL_MY_AMF:String = "my-amf";
				
//				public var _servletMessagebrokerAmf:String = DFxGUIConstants._BLAZEDS_MESSAGEBROKER_AMF;
//				public var _channelID:String = DFxGUIConstants._BLAZEDS_CHANNEL_MY_AMF;
//				public var _channelURL:String = DFxGUIParameters._applicationURL + DFxGUIConstants._CHAR_FORWARD_SLASH + _servletMessagebrokerAmf;
				
//				const channelSet:ChannelSet = new ChannelSet();
//				channelSet.addChannel(new AMFChannel(_channelID, _channelURL));
//				channelSet.addChannel(new AMFChannel("my-amf-" + DFxGUIParameters._applicationName, DFxGUIParameters._applicationURL + "/messagebroker" + DFxGUIParameters._applicationName + "/amf"));
				
				
				
				const dest:Array = destination.split("\.");
				
				
				
				const remoteObject:DBlazeDSRemoteObject = new DBlazeDSRemoteObject();
				remoteObject._dBeanBlazeDS = dBeanBlazeDS;
				remoteObject.destination = dest[0];
				remoteObject.channelSet = _channelSet;
				remoteObject.addEventListener(ResultEvent.RESULT, doInvokeSuccess);
				remoteObject.addEventListener(FaultEvent.FAULT, invokeFault);
				remoteObject.initialized(null, (++_messageCounter).toString());

				if (caller)
					_executingCommands[caller] = remoteObject;

//				const parameters:Object = new Object();
//				parameters.pkgClassMethod = dBeanBlazeDS._pkgClassMethod;
//				parameters.parameters = dBeanBlazeDS._parameters;

				if (delayTime > 0)
				{
					const timer:Timer = new Timer(delayTime, 1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayTimeComplete);

					if (!_delayedTimers)
						_delayedTimers = new Dictionary();

					_delayedTimers[timer] = [ remoteObject, parameters ];

					timer.start();
				}
				else
					remoteObject.getOperation(dest[1]).send(parameters);
			}
		}

		public function cancelOperation(caller:UIComponent):void
		{
			const remoteObj:DBlazeDSRemoteObject = _executingCommands[caller];

			if (remoteObj)
			{
				(remoteObj.channelSet as ChannelSet).logout();
				(remoteObj.channelSet as ChannelSet).disconnectAll()
				remoteObj.removeEventListener(ResultEvent.RESULT, doInvokeSuccess);
				remoteObj.removeEventListener(FaultEvent.FAULT, invokeFault);
				releaseCaller(caller);
			}
		}

		public function addLock(caller:UIComponent):void
		{
			resolveCaller(caller);

			if (!caller)
				caller = _mainCaller;

			_executingCommands[caller] = {};
		}

		public function releaseLock(caller:UIComponent):void
		{
			releaseCaller(caller);
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public static interface:

		public static function showInExecutionMessage():void
		{
			DNotificator.showWarning(StrConsts.getRMString(1));
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Private interface:

		private function resolveCaller(caller:UIComponent):void
		{
			if (caller)
			{
				if (_mainCaller)
					_mainCaller.enabled = false;

				caller.enabled = false;
			}
			else
				caller = _mainCaller;
		}

		private function releaseCaller(caller:UIComponent):void
		{
			if (caller)
				if (_executingCommands[caller])
				{
					delete _executingCommands[caller];

					if (caller == _mainCaller)
					{
						if (!hasExecutingCommands())
							caller.enabled = true;
					}
					else
					{
						if (!hasExecutingCommands())
							if (_mainCaller)
								_mainCaller.enabled = true;

						caller.enabled = true;
					}
				}
		}

		//----------------------------------------------------------------------
		// Success handling:

		private function doInvokeSuccess(event:ResultEvent):void
		{
			const dBeanBlazeDS:DBeanBlazeDS = (event.currentTarget as DBlazeDSRemoteObject)._dBeanBlazeDS;
			releaseCaller(dBeanBlazeDS._caller);

			if (event)
			{
				const resultObj:Object = event.result;

				if (resultObj)
				{
					if (resultObj is String)
					{
						const resultStr:String = resultObj as String;

						if (resultStr)
						{
							const decoder:ServerVarsDecoder = new ServerVarsDecoder(resultStr);
							const messageType:int = decoder.getMessageType();
							const value:String = decoder.getValue();
							const resourceBundleSource:String = decoder.getResourceBundleSource();

							if (decoder._isServerVar)
							{
								if (resourceBundleSource == StrConsts._STR_d || resourceBundleSource == StrConsts._STR_D)
								{
									if (dBeanBlazeDS._callbackFault != null)
										dBeanBlazeDS._callbackFault(StrConsts.getRMString(int(value)));
									else
										showRawFaultMessage(StrConsts.getRMString(int(value)), messageType, false);
								}
								else
									dBeanBlazeDS._callbackSucess(ResourceManager.getInstance().getString(XFrontConfigurator._applicationResourceBundle, value));
							}
							else
								dBeanBlazeDS._callbackSucess(value);
						}
						else
							dBeanBlazeDS._callbackSucess("Ação executada corretamente, porém, nenhuma resposta do servidor foi recebida.");
					}
					else
						dBeanBlazeDS._callbackSucess(resultObj);
				}
				else
					dBeanBlazeDS._callbackSucess(null);
			}
			else
				dBeanBlazeDS._callbackSucess("BlazeDS.doInvoke.ResultEvent-RESULT: event == null"); // TODO: Teste temporário.
		}

		private function onSucessDefault(returnObj:Object):void
		{
			DNotificator.showInfo(returnObj.toString());
		}

		//----------------------------------------------------------------------
		// Fault handling:

		protected function invokeFault(event:FaultEvent):void
		{
			// TODO: REMOVE THIS?
//			const dBeanBlazeDS:DBeanBlazeDS = (event.currentTarget as DBlazeDSRemoteObject)._dBeanBlazeDS;
//			releaseCaller(dBeanBlazeDS._caller);

			const errorMessage:ErrorMessage = ErrorMessage(event.message);

			if (errorMessage)
			{
				const serverUnreachableMsg:String = serverUnreachable(errorMessage);

				if (serverUnreachableMsg)
					DNotificator.showError(serverUnreachableMsg, "2239");
				else
				{
					var faultString:String = errorMessage.faultString;
					const extendedData:Object = errorMessage.extendedData;

					if (extendedData)
						faultString += resolveFaultExtendedData(extendedData);

//					const rootCause:Object = errorMessage.rootCause;
//					const exceptionName:String = rootCause.exceptionName;
//					const message:String = rootCause.message;
//					const messageType:int = rootCause.messageType;
//					const origin:String = rootCause.origin;
//					const showNotificator:Boolean = rootCause.showNotificator;
//					const rootException:Object = rootCause.rootException;
//
//					var sqlState:String;
//					if (rootException)
//						sqlState = rootException.SQLState;
//
//					var resolvedMessage:String;
//
//					if (exceptionName == "DException" || exceptionName == "DGUIException" || exceptionName == "DGUIErrorException")
//						rootCause.message = resolvedMessage = ServerVarsDecoder.replaceAllMessageDVars(message, origin);
//					else if (exceptionName == "DGUIErrorCodeException")
//						rootCause.message = resolvedMessage = DFxGUIConstants.getRMErrorString(message);
//					else if (exceptionName == "HibernateJDBCException")
//						if (message == "JDBCException")
//							resolvedMessage = ServerVarsDecoder.replaceMessageDVarCode(sqlState, origin);

//					if (showNotificator)
					DNotificator.showWarning(faultString);

//					if (dBeanBlazeDS._callbackFault != null)
//						dBeanBlazeDS._callbackFault(rootCause);
				}
			}
			else
			{
				DNotificator.showError(Msgs.grab("unknown.error"), "2243");
				throw event;
			}

//			if (dBeanBlazeDS._callbackFault != null)
//				dBeanBlazeDS._callbackFault(event);
		}

		protected function serverUnreachable(errorMessage:ErrorMessage):String
		{
			const serverUnreachableMsg:String = Msgs.grab("server.unreachable");
			const faultCode:String = errorMessage.faultCode;

			if (faultCode == ERR_Channel_Call_Failed)
				return serverUnreachableMsg + " (" + ERR_Channel_Call_Failed + ")";
			else if (faultCode == ERR_Client_Error_MessageSend)
				return serverUnreachableMsg + " (" + ERR_Client_Error_MessageSend + ")";
			else
				return null;
		}

		protected function resolveFaultExtendedData(extendedData:Object):String
		{
			const field:String = extendedData.field;
			const value:String = extendedData.value;

			var finalStr:String = "\n\n";

			if (field)
			{
				// First we check if the field name is the key to a message in the application resource bundle file. If yes, we use it.
				const translatedField:String = ResourceManager.getInstance().getString(XFrontConfigurator._applicationResourceBundle, field)

				if (translatedField)
					finalStr += translatedField;
				else
				{
					// TODO: GET FROM REGISTRY.
				}
			}

			if (value)
				finalStr += " \"" + value + "\"";

			return finalStr != "\n\n" ? finalStr : "";
		}

		//----------------------------------------------------------------------

		
		
		
		





		private function onDelayTimeComplete(event:TimerEvent):void
		{
			const timer:Timer = event.currentTarget as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDelayTimeComplete);

			const parameters:Array = _delayedTimers[timer];
			parameters[0].getService(parameters[1]);

			delete _delayedTimers[timer];
		}

		private function getExecutingCommandsLength():int
		{
			var i:int = 0;
			for (var key:* in _executingCommands)
				i++;

			return i;
		}

		private function hasExecutingCommands():Boolean
		{
			for (var key:* in _executingCommands)
				return true

			return false;
		}

		protected function showRawFaultMessage(returnObj:Object, messageType:int=4, isToRemovePkgClassMethod:Boolean=true):void
		{
			if (returnObj is FaultEvent)
			{
				const faultEvent:FaultEvent = returnObj as FaultEvent;
				if (faultEvent.fault)
				{
					const fault:Fault = faultEvent.fault as Fault;
					if (fault.rootCause)
						DNotificator.show(fault.rootCause.message, null, messageType, DNotificator._NOTIFICATION_POSITION_TOP_CENTER);
				}
			}
			/*if (returnObj is String)
			DNotificator.show(returnObj.toString(), null, messageType, DNotificator._NOTIFICATION_POSITION_TOP_CENTER);*/ // TODO: No focus manager on this notification.
			/*else
			DNotificator.show((returnObj as FaultEvent).fault.toString(), null, messageType, DNotificator._NOTIFICATION_POSITION_TOP_CENTER);*/ // TODO: No focus manager on this notification.
		}

		//----------------------------------------------------------------------
	}
}
