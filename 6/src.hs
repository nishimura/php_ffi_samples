{-# LANGUAGE ForeignFunctionInterface #-}

#include "template_operations.h"

module HaskellPhp where

import Foreign
import Foreign.C.String
import Foreign.C.Types
import Data.IORef
import System.IO.Unsafe

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


--
-- Function to parse some string
--
parse :: CString -> Ptr Tops -> IO CString
parse cs cops = do
  ops <- peek cops
  let f = mkFun $ assign ops
  a <- newCString "foo"
  b <- newCString "bar"
  r <-  f a b
  cstr <- return_value_get
  s <- peekCString cstr
  newCString $ "parse finish: [" ++ show r ++ "]" ++ "[" ++ s ++ "]"
