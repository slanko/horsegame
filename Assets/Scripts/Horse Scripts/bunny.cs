using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class bunny : MonoBehaviour
{
    Rigidbody rb;
    horseFunctionsScript hFS;
    godScript GOD;
    public float changeAmount;
    horseBehaviour hB;
    public float jumpForce = 10;
    bool grounded;
    private void Start()
    {
        hB = GetComponent<horseBehaviour>();
        hFS = GetComponent<horseFunctionsScript>();
        GOD = GameObject.Find("GOD").GetComponent<godScript>();
        rb = GetComponent<Rigidbody>();
    }
    public void meJump()
    {
        if (hFS.cC.currentState == characterController.playerState.TAMING)
        {
            rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
            GOD.tamingSlider.value = GOD.tamingSlider.value + changeAmount;
            Invoke("meJump", Random.Range(hFS.tamingEventTimeBounds.x, hFS.tamingEventTimeBounds.y));
        }
    }


    private void Update()
    {
        if (hB.beingRidden == true && hB.isTamed == true && grounded == true)
        {
            if (Input.GetKey(KeyCode.Space))
            {
                rb.AddForce(Vector3.up * jumpForce, ForceMode.VelocityChange);
                grounded = false;
            }
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if(collision.gameObject.tag == "ground")
        {
            grounded = true;
        }
    }

    private void OnCollisionExit(Collision collision)
    {
        if(collision.gameObject.tag == "grounded")
        {
            grounded = false;
        }
    }
}
