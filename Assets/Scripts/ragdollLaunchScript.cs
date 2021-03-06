﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ragdollLaunchScript : MonoBehaviour
{
    bool launched = false;
    bool resetInvoked = false;
    public bool willLaunch;
    public float launchForce;
    Rigidbody rb;
    public GameObject myHips;
    characterController cC;
    // Start is called before the first frame update
    void Start()
    {
        cC = GameObject.Find("Player").GetComponent<characterController>();
        rb = myHips.GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        Debug.Log(rb.velocity.magnitude);
        if(willLaunch == true)
        {
            if (launched == false)
            {
                rb.AddForce(Vector3.up * launchForce * 1000);
                launched = true;
            }
        }

        if(rb.velocity.magnitude < 1)
        {
            if(resetInvoked == false)
            {
                StartCoroutine(ragdollReset());
                resetInvoked = true;
            }
        }
    }

    IEnumerator ragdollReset()
    {
        Debug.Log("bing");
        yield return new WaitForSeconds(3);
        if (rb.velocity.magnitude < 1)
        {
            cC.goToGrounded();
            Debug.Log("bong");
            cC.gameObject.transform.SetParent(null);
            cC.gameObject.transform.position = myHips.transform.position;
            Destroy(gameObject);
        }
        else
        {
            StartCoroutine(ragdollReset());
        }
    }

}
