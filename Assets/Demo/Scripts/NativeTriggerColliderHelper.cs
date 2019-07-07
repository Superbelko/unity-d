using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System.Runtime.CompilerServices;

// Native callback helper
public class NativeTriggerColliderHelper : MonoBehaviour
{
    [MethodImpl(MethodImplOptions.InternalCall)]
    private extern void OnTriggerEnter_Native(Collider other);

    [MethodImpl(MethodImplOptions.InternalCall)]
    private extern void OnTriggerExit_Native(Collider other);

    private void OnTriggerEnter(Collider other)
    {
        OnTriggerEnter_Native(other);
    }

    private void OnTriggerExit(Collider other)
    {
        OnTriggerExit_Native(other);
    }
}
