{-# LANGUAGE ForeignFunctionInterface #-}

#include "template_operations.h"

module Bridge where

import Foreign
import Foreign.C.String
import Foreign.C.Types
import Data.IORef
import System.IO.Unsafe

import qualified HsTemplate

data Tops = Tops { assign::FunPtr (CString -> CString -> IO CInt) }

foreign export ccall parse :: CString -> Ptr Tops -> IO CString
foreign export ccall return_value_set :: CString -> IO ()
foreign export ccall return_value_get :: IO CString

foreign import ccall "dynamic" mkFun :: FunPtr (CString -> CString -> IO CInt)
                                     -> (CString -> CString -> IO CInt)


instance Storable Tops where
    sizeOf _ = #size CTOPS
    alignment _ = #alignment CTOPS
    peek ptr = do
      assign' <- (#peek CTOPS, assign) ptr
      return Tops { assign=assign' }
    poke ptr (Tops assign') = do
                           (#poke CTOPS, assign) ptr assign'



{-# NOINLINE return_value #-}
return_value :: IORef CString
return_value = unsafePerformIO $ newCString "" >>= newIORef

return_value_set :: CString -> IO ()
return_value_set a = writeIORef return_value a

return_value_get :: IO CString
return_value_get = readIORef return_value



wrapCallback :: (CString -> CString -> IO CInt) -> (String -> String -> IO String)
wrapCallback f = f'
  where f' a b = do
          ca <- newCString a
          cb <- newCString b
          _ <- f ca cb -- call return_value_set by internal callback
          cret <- return_value_get
          ret <- peekCString cret
          return ret

--
-- Function to parse some string
--
parse :: CString -> Ptr Tops -> IO CString
parse cs cops = do
  ops <- peek cops
  let f = mkFun $ assign ops
      wrapper = wrapCallback f
  s <- peekCString cs
  HsTemplate.parse s wrapper >>= newCString
