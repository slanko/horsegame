using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class bunny : MonoBehaviour
{
    Rigidbody rb;
    horseFunctionsScript hFS;
    godScript GOD;
    public float changeAmount;
    private void Start()
    {
        hFS = GetComponent<horseFunctionsScript>();
        GOD = GameObject.Find("GOD").GetComponent<godScript>();
        rb = GetComponent<Rigidbody>();
    }
    public void meJump()
    {
        if (hFS.cC.currentState == characterController.playerState.TAMING)
        {
            rb.AddForce(Vector3.up * 10, ForceMode.Impulse);
            GOD.tamingSlider.value = GOD.tamingSlider.value + changeAmount;
            Invoke("meJump", Random.Range(hFS.tamingEventTimeBounds.x, hFS.tamingEventTimeBounds.y));
        }
    }
}
